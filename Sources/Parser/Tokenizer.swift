import Foundation

struct ByteStream {
  var position: Int = 0
  var data: Data
}

// https://infra.spec.whatwg.org/#normalize-newlines

func normalizeNewlines(_ data: inout Data) {
  // in a string, replace every U+000D CR U+000A LF code point pair with a single U+000A LF code point, and then replace every remaining U+000D CR code point with a U+000A LF code point.
  var currentIndex = data.startIndex
  while currentIndex < data.endIndex {
    if currentIndex < data.index(before: data.endIndex),
      data[currentIndex] == 0x0D,
      data[data.index(after: currentIndex)] == 0x0A
    {
      // Replace U+000D CR U+000A LF code point pair with a single U+000A LF code point
      data.replaceSubrange(currentIndex..<data.index(currentIndex, offsetBy: 2), with: [0x0A])
      currentIndex = data.index(after: currentIndex)
    } else if data[currentIndex] == 0x0D {
      // Replace standalone U+000D CR with U+000A LF code point
      data[currentIndex] = 0x0A
    }
    currentIndex = data.index(after: currentIndex)
  }
}

extension Character {
  // https://infra.spec.whatwg.org/#ascii-alphanumeric
  // An ASCII digit is a code point in the range U+0030 (0) to U+0039 (9), inclusive.
  var isASCIIDigit: Bool {
    return "0"..."9" ~= self
  }
  // An ASCII upper hex digit is an ASCII digit or a code point in the range U+0041 (A) to U+0046 (F), inclusive.
  var isASCIIUpperHexDigit: Bool {
    return isASCIIDigit || "A"..."F" ~= self
  }

  // An ASCII lower hex digit is an ASCII digit or a code point in the range U+0061 (a) to U+0066 (f), inclusive.
  var isASCIILowerHexDigit: Bool {
    return isASCIIDigit || "a"..."f" ~= self
  }

  // An ASCII hex digit is an ASCII upper hex digit or ASCII lower hex digit.
  var isASCIIHexDigit: Bool {
    return isASCIIUpperHexDigit || isASCIILowerHexDigit
  }

  // An ASCII upper alpha is a code point in the range U+0041 (A) to U+005A (Z), inclusive.
  var isASCIIUpperAlpha: Bool {
    return "A"..."Z" ~= self
  }

  // An ASCII lower alpha is a code point in the range U+0061 (a) to U+007A (z), inclusive.
  var isASCIILowerAlpha: Bool {
    return "a"..."z" ~= self
  }

  // An ASCII alpha is an ASCII upper alpha or ASCII lower alpha.
  var isASCIIAlpha: Bool {
    return isASCIIUpperAlpha || isASCIILowerAlpha
  }

  // An ASCII alphanumeric is an ASCII digit or ASCII alpha.
  var isASCIIAlphanumeric: Bool {
    return isASCIIDigit || isASCIIAlpha
  }

}

public enum TokenizerState {
  case data
  case rcData
  case rawText
  case scriptData
  case tagOpen
  case endTagOpen
  case tagName
  case rcDataLessThanSign
  case rcDataEndTagOpen
  case rcDataEndTagName
  case rawTextLessThanSign
  case rawTextEndTagOpen
  case rawTextEndTagName
  case scriptDataEscapeStart
  case scriptDataEscapeStartDash
  case scriptDataEscaped
  case scriptDataEscapedDash
  case scriptDataEscapedDashDash
  case scriptDataEscapedLessThanSign
  case scriptDataEscapedEndTagOpen
  case scriptDataEscapedEndTagName
  case scriptDataDoubleEscapeStart
  case scriptDataDoubleEscaped
  case scriptDataDoubleEscapedDash
  case scriptDataDoubleEscapedDashDash
  case scriptDataDoubleEscapedLessThanSign
  case scriptDataDoubleEscapeEnd
  case beforeAttributeName
  case attributeName
  case afterAttributeName
  case beforeAttributeValue
  case attributeValueDoubleQuoted
  case attributeValueSingleQuoted
  case attributeValueUnquoted
  case afterAttributeValueQuoted
  case selfClosingStartTag
  case bogusComment
  case markupDeclarationOpen
  case commentStart
  case commentStartDash
  case comment
  case commentLessThanSign
  case commentLessThanSignBang
  case commentLessThanSignBangDash
  case commentLessThanSignBangDashDash
  case commentEndDash
  case commentEnd
  case commentEndBang
  case doctype
  case beforeDoctypeName
  case doctypeName
  case afterDoctypeName
  case afterDoctypePublicKeyword
  case beforeDoctypePublicIdentifier
  case doctypePublicIdentifierDoubleQuoted
  case doctypePublicIdentifierSingleQuoted
  case afterDoctypePublicIdentifier
  case betweenDoctypePublicAndSystemIdentifiers
  case afterDoctypeSystemKeyword
  case beforeDoctypeSystemIdentifier
  case doctypeSystemIdentifierDoubleQuoted
  case doctypeSystemIdentifierSingleQuoted
  case afterDoctypeSystemIdentifier
  case bogusDoctype
  case cdataSection
  case cdataSectionBracket
  case cdataSectionEnd
  case characterReference
  case namedCharacterReference
  case ambiguousAmpersand
  case numericCharacterReference
  case hexadecimalCharacterReferenceStart
  case decimalCharacterReferenceStart
  case hexadecimalCharacterReference
  case decimalCharacterReference
  case numericCharacterReferenceEnd
}

public enum Token {
  case character(Character)
  case startTag(_ tag: String, attributes: [Attr] = [], isSelfClosing: Bool = false)
  case endTag(String, attributes: [Attr] = [], isSelfClosing: Bool = false)
  case comment(String)
  case doctype(name: String, publicId: String?, systemId: String?, forceQuirks: Bool)
  case attribute(name: String, value: String)
  case eof

}

typealias EmitFunc = (Token) -> Void

public protocol TokenReceiver {
  func didReceiveToken(_ token: Token)
}

class Tokenizer {
  var position = -1
  var data: Data
  var state: TokenizerState = .data
  var returnState: TokenizerState = .data
  public var delegate: TokenReceiver?
  var currentToken: Token?
  var reconsumeNext = false
  var temporaryBuffer = ""

  init(data: Data) {
    self.data = data
  }

  func isEOF() -> Bool {
    return data.count <= position
  }

  func consumeNextInputCharacter() -> Character? {
    if reconsumeNext {
      reconsumeNext = false
    } else {
      position += 1
    }
    let char = self.currentInputCharacter()
    return char
  }

  func currentInputCharacter() -> Character? {
    if isEOF() {
      return nil
    }

    return Character(UnicodeScalar(data[position]))
  }

  func emitCharacterToken(_ character: Character) {
    self.delegate?.didReceiveToken(.character(character))
  }

  func emitEndOfFileToken() {
    self.delegate?.didReceiveToken(.eof)
  }

  func emitCurrentToken() {
    guard let token = self.currentToken else {
      assertionFailure()
      return
    }
    self.delegate?.didReceiveToken(token)
  }

  func createAttribute(name: String = "", value: String = "") {
    switch self.currentToken {
    case .startTag(let tag, let attributes, let isSelfClosing):
      self.currentToken = .startTag(tag, attributes: attributes + [Attr(name: name, value: value)], isSelfClosing: isSelfClosing)
    default:
      assertionFailure()
      exit(0)
    }
  }

  func currentAttributeAppendToName(_ name: String) {
    guard case .startTag(let tag, var attributes, let isSelfClosing) = self.currentToken else {
      assertionFailure()
      return
    }

    if let lastAttribute = attributes.last {
      attributes[attributes.count - 1] = Attr(
        name: lastAttribute.name + name, value: lastAttribute.value
      )
    }

    self.currentToken = .startTag(tag, attributes: attributes, isSelfClosing: isSelfClosing)
  }

  func currentAttributeAppendToValue(_ value: String) {
    switch self.currentToken {
    case .startTag(let tag, var attributes, let isSelfClosing):
      if let lastAttribute = attributes.last {
        attributes[attributes.count - 1] = Attr(
          name: lastAttribute.name, value: lastAttribute.value + value
        )
      }
      self.currentToken = .startTag(tag, attributes: attributes, isSelfClosing: isSelfClosing)
    default:
      assertionFailure()
      return
    }
  }

  func appendCurrenTagTokenName(_ character: Character) {
    switch self.currentToken {
    case .startTag(let name, let attributes, let isSelfClosing):
      self.currentToken = .startTag(name + String(character), attributes: attributes, isSelfClosing: isSelfClosing)
    case .endTag(let name, let attributes, let isSelfClosing):
      self.currentToken = .endTag(name + String(character), attributes: attributes, isSelfClosing: isSelfClosing)
    case .comment(let name):
      self.currentToken = .comment(name + String(character))
    default:
      print("Implement me: \(self.currentToken!)")
      exit(0)
    }
  }

  func currentDocTypeAppendToName(_ s: String) {
    switch self.currentToken {
    case .doctype(let name, let publicId, let systemId, let forceQuirks):
      self.currentToken = .doctype(
        name: name + s, publicId: publicId, systemId: systemId,
        forceQuirks: forceQuirks)
    default:
      assertionFailure()
      exit(0)
    }
  }

  func currentDocTypeSetForceQuirksFlag(_ forceQuirks: Bool) {
    switch self.currentToken {
    case .doctype(let name, let publicId, let systemId, _):
      self.currentToken = .doctype(
        name: name, publicId: publicId, systemId: systemId,
        forceQuirks: forceQuirks)
    default:
      assertionFailure()
      exit(0)
    }
  }

  func reconsume(_ state: TokenizerState) {
    self.reconsumeNext = true
    self.state = state
  }

  // https://html.spec.whatwg.org/multipage/parsing.html#flush-code-points-consumed-as-a-character-reference
  func flushCodePointsConsumedAsCharacterReference() {
    // When a state says to flush code points consumed as a character reference, it means that for each code point
    // in the temporary buffer (in the order they were added to the buffer) user agent must append the code point
    // from the buffer to the current attribute's value if the character reference was consumed as part of an attribute,
    //  or emit the code point as a character token otherwise.
    for char in self.temporaryBuffer {
      if case .attribute = self.currentToken,
        [.attributeValueDoubleQuoted, .attributeValueSingleQuoted, .attributeValueUnquoted]
          .contains(self.returnState)
      {
        self.currentAttributeAppendToValue(String(char))
      } else {
        self.emitCharacterToken(char)
      }
    }
  }

  func tokenize() {
    while !self.isEOF() {
      self.nextToken()
    }
  }

  func nextToken() {
    switch state {
    // 13.2.5.1 Data state
    case .data:
      handleDataState()

    // 13.2.5.2 RCDATA state
    // 13.2.5.3 RAWTEXT state
    // 13.2.5.4 Script data state
    // 13.2.5.5 PLAINTEXT state

    // 13.2.5.6 Tag open state
    case .tagOpen:
      handleTagOpenState()

    // 13.2.5.7 End tag open state
    case .endTagOpen:
      handleEndTagOpenState()

    // 13.2.5.8 Tag name state
    case .tagName:
      handleTagNameState()

    // 13.2.5.9 RCDATA less-than sign state
    // 13.2.5.10 RCDATA end tag open state
    // 13.2.5.11 RCDATA end tag name state
    // 13.2.5.12 RAWTEXT less-than sign state
    // 13.2.5.13 RAWTEXT end tag open state
    // 13.2.5.14 RAWTEXT end tag name state
    // 13.2.5.15 Script data less-than sign state
    // 13.2.5.16 Script data end tag open state
    // 13.2.5.17 Script data end tag name state
    // 13.2.5.18 Script data escape start state
    // 13.2.5.19 Script data escape start dash state
    // 13.2.5.20 Script data escaped state
    // 13.2.5.21 Script data escaped dash state
    // 13.2.5.22 Script data escaped dash dash state
    // 13.2.5.23 Script data escaped less-than sign state
    // 13.2.5.24 Script data escaped end tag open state
    // 13.2.5.25 Script data escaped end tag name state
    // 13.2.5.26 Script data double escape start state
    // 13.2.5.27 Script data double escaped state
    // 13.2.5.28 Script data double escaped dash state
    // 13.2.5.29 Script data double escaped dash dash state
    // 13.2.5.30 Script data double escaped less-than sign state
    // 13.2.5.31 Script data double escape end state
    // 13.2.5.32 Before attribute name state
    case .beforeAttributeName:
      handleBeforeAttributeNameState()

    // 13.2.5.33 Attribute name state
    case .attributeName:
      handleAttributeNameState()

    // 13.2.5.34 After attribute name state
    // 13.2.5.35 Before attribute value state
    case .beforeAttributeValue:
      handleBeforeAttributeValueState()

    // 13.2.5.36 Attribute value (double-quoted) state
    case .attributeValueDoubleQuoted:
      handleAttributeValueDoubleQuotedState()

    // 13.2.5.37 Attribute value (single-quoted) state
    case .attributeValueSingleQuoted:
      handleAttributeValueSingleQuotedState()

    // 13.2.5.38 Attribute value (unquoted) state
    case .attributeValueUnquoted:
      handleAttributeValueUnquotedState()

    // 13.2.5.39 After attribute value (quoted) state
    case .afterAttributeValueQuoted:
      handleAfterAttributeValueQuotedState()

    // 13.2.5.40 Self-closing start tag state

    // 13.2.5.41 Bogus comment state
    case .bogusComment:
      handleBogusCommentState()

    // 13.2.5.42 Markup declaration open state
    case .markupDeclarationOpen:
      handleMarkupDeclarationOpenState()

    // 13.2.5.43 Comment start state
    case .commentStart:
      handleCommentStartState()

    // 13.2.5.44 Comment start dash state
    // 13.2.5.45 Comment state
    case .comment:
      handleCommentState()

    // 13.2.5.46 Comment less-than sign state
    // 13.2.5.47 Comment less-than sign bang state
    // 13.2.5.48 Comment less-than sign bang dash state
    // 13.2.5.49 Comment less-than sign bang dash dash state
    // 13.2.5.50 Comment end dash state
    case .commentEndDash:
      handleCommentEndDashState()

    // 13.2.5.51 Comment end state
    case .commentEnd:
      handleCommentEndState()

    // 13.2.5.52 Comment end bang state
    // 13.2.5.53 DOCTYPE state
    case .doctype:
      handleDoctypeState()

    // 13.2.5.54 Before DOCTYPE name state
    case .beforeDoctypeName:
      handleBeforeDoctypeNameState()

    // 13.2.5.55 DOCTYPE name state
    case .doctypeName:
      handleDoctypeNameState()

    // 13.2.5.56 After DOCTYPE name state
    // 13.2.5.57 After DOCTYPE public keyword state
    // 13.2.5.58 Before DOCTYPE public identifier state
    // 13.2.5.59 DOCTYPE public identifier (double-quoted) state
    // 13.2.5.60 DOCTYPE public identifier (single-quoted) state
    // 13.2.5.61 After DOCTYPE public identifier state
    // 13.2.5.62 Between DOCTYPE public and system identifiers state
    // 13.2.5.63 After DOCTYPE system keyword state
    // 13.2.5.64 Before DOCTYPE system identifier state
    // 13.2.5.65 DOCTYPE system identifier (double-quoted) state
    // 13.2.5.66 DOCTYPE system identifier (single-quoted) state
    // 13.2.5.67 After DOCTYPE system identifier state
    // 13.2.5.68 Bogus DOCTYPE state
    // 13.2.5.69 CDATA section state
    // 13.2.5.70 CDATA section bracket state
    // 13.2.5.71 CDATA section end state
    // 13.2.5.72 Character reference state
    case .characterReference:
      handleCharacterReferenceState()

    // 13.2.5.73 Named character reference state
    // 13.2.5.74 Ambiguous ampersand state
    // 13.2.5.75 Numeric character reference state
    // 13.2.5.76 Hexadecimal character reference start state
    // 13.2.5.77 Decimal character reference start state
    // 13.2.5.78 Hexadecimal character reference state
    // 13.2.5.79 Decimal character reference state
    // 13.2.5.80 Numeric character reference end state

    default:
      print("Implement me, \(state)")
      exit(0)
    }
  }

  // 13.2.5.1 Data state https://html.spec.whatwg.org/multipage/parsing.html#data-state
  func handleDataState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+0026 AMPERSAND (&)
    case "&":
      // Set the return state to the data state. Switch to the character reference state.
      self.returnState = .data
      self.state = .characterReference

    // U+003C LESS-THAN SIGN (<)
    case "<":
      // Switch to the tag open state.
      self.state = .tagOpen

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error. Emit the current input character as a character token.
      emitCharacterToken(currentInputCharacter()!)

    // EOF
    case nil:
      // Emit an end-of-file token.
      emitEndOfFileToken()

    // Anything else
    default:
      // Emit the current input character as a character token.
      emitCharacterToken(currentInputCharacter()!)
    }
  }

  // 13.2.5.2 RCDATA state
  // Consume the next input character:
  // U+0026 AMPERSAND (&)
  // Set the return state to the RCDATA state. Switch to the character reference state.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the RCDATA less-than sign state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.3 RAWTEXT state
  // Consume the next input character:
  // U+003C LESS-THAN SIGN (<)
  // Switch to the RAWTEXT less-than sign state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.4 Script data state
  // Consume the next input character:
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data less-than sign state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.5 PLAINTEXT state
  // Consume the next input character:
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.6 Tag open state https://html.spec.whatwg.org/multipage/parsing.html#tag-open-state
  func handleTagOpenState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {
    // U+0021 EXCLAMATION MARK (!)
    case "!":
      // Switch to the markup declaration open state.
      self.state = .markupDeclarationOpen

    // U+002F SOLIDUS (/)
    case "/":
      // Switch to the end tag open state.
      self.state = .endTagOpen

    // ASCII alpha
    case let char where char!.isLetter:
      // Create a new start tag token, set its tag name to the empty string.
      self.currentToken = .startTag("")
      // Reconsume in the tag name state.
      self.reconsume(.tagName)

    // U+003F QUESTION MARK (?)
    case "?":
      // This is an unexpected-question-mark-instead-of-tag-name parse error. Create a comment token whose data is the empty string. Reconsume in the bogus comment state.
      self.currentToken = .comment("")
      self.reconsume(.bogusComment)

    // EOF
    case nil:
      // This is an eof-before-tag-name parse error. Emit a U+003C LESS-THAN SIGN character token and an end-of-file token.
      emitCharacterToken("<")
      emitEndOfFileToken()

    // Anything else
    default:
      // This is an invalid-first-character-of-tag-name parse error. Emit a U+003C LESS-THAN SIGN character token. Reconsume in the data state.
      emitCharacterToken("<")
      self.reconsume(.data)
    }
  }

  // 13.2.5.7 End tag open state https://html.spec.whatwg.org/multipage/parsing.html#end-tag-open-state
  func handleEndTagOpenState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {
    // ASCII alpha
    // Create a new end tag token, set its tag name to the empty string. Reconsume in the tag name state.
    case let char where char!.isLetter:
      self.currentToken = .endTag("")
      self.reconsume(.tagName)

    // U+003E GREATER-THAN SIGN (>)
    // This is a missing-end-tag-name parse error. Switch to the data state.
    case ">":
      self.state = .data

    // EOF
    // This is an eof-before-tag-name parse error. Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token and an end-of-file token.
    case nil:
      emitCharacterToken("<")
      emitCharacterToken("/")
      emitEndOfFileToken()

    // Anything else
    // This is an invalid-first-character-of-tag-name parse error. Create a comment token whose data is the empty string. Reconsume in the bogus comment state.
    default:
      self.currentToken = .comment("")
      self.reconsume(.bogusComment)
    }
  }

  // 13.2.5.8 Tag name state https://html.spec.whatwg.org/multipage/parsing.html#tag-name-state
  func handleTagNameState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {
    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\r", " ":
      // Switch to the before attribute name state.
      self.state = .beforeAttributeName

    // U+002F SOLIDUS (/)
    case "/":
      // Switch to the self-closing start tag state.
      self.state = .selfClosingStartTag

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state. Emit the current tag token.
      self.state = .data
      self.delegate?.didReceiveToken(self.currentToken!)

    // ASCII upper alpha
    // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name.
    case let char where char!.isUppercase:
      let cic = currentInputCharacter()!
      self.appendCurrenTagTokenName(
        Character(UnicodeScalar(cic.unicodeScalars.first!.value + 0x0020)!))

    // U+0000 NULL
    // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current tag token's tag name.
    case "\0":
      self.appendCurrenTagTokenName("\u{FFFD}")

    // EOF
    // This is an eof-in-tag parse error. Emit an end-of-file token.
    case nil:
      emitEndOfFileToken()

    // Anything else
    // Append the current input character to the current tag token's tag name.
    default:
      self.appendCurrenTagTokenName(currentInputCharacter()!)
    }
  }

  // 13.2.5.9 RCDATA less-than sign state
  // Consume the next input character:
  // U+002F SOLIDUS (/)
  // Set the temporary buffer to the empty string. Switch to the RCDATA end tag open state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token. Reconsume in the RCDATA state.

  // 13.2.5.10 RCDATA end tag open state
  // Consume the next input character:
  // ASCII alpha
  // Create a new end tag token, set its tag name to the empty string. Reconsume in the RCDATA end tag name state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the RCDATA state.

  // 13.2.5.11 RCDATA end tag name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
  // U+002F SOLIDUS (/)
  // If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
  // U+003E GREATER-THAN SIGN (>)
  // If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
  // ASCII lower alpha
  // Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the RCDATA state.

  // 13.2.5.12 RAWTEXT less-than sign state
  // Consume the next input character:
  // U+002F SOLIDUS (/)
  // Set the temporary buffer to the empty string. Switch to the RAWTEXT end tag open state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token. Reconsume in the RAWTEXT state.

  // 13.2.5.13 RAWTEXT end tag open state
  // Consume the next input character:
  // ASCII alpha
  // Create a new end tag token, set its tag name to the empty string. Reconsume in the RAWTEXT end tag name state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the RAWTEXT state.

  // 13.2.5.14 RAWTEXT end tag name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
  // U+002F SOLIDUS (/)
  // If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
  // U+003E GREATER-THAN SIGN (>)
  // If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
  // ASCII lower alpha
  // Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the RAWTEXT state.

  // 13.2.5.15 Script data less-than sign state
  // Consume the next input character:
  // U+002F SOLIDUS (/)
  // Set the temporary buffer to the empty string. Switch to the script data end tag open state.
  // U+0021 EXCLAMATION MARK (!)
  // Switch to the script data escape start state. Emit a U+003C LESS-THAN SIGN character token and a U+0021 EXCLAMATION MARK character token.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token. Reconsume in the script data state.

  // 13.2.5.16 Script data end tag open state
  // Consume the next input character:
  // ASCII alpha
  // Create a new end tag token, set its tag name to the empty string. Reconsume in the script data end tag name state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the script data state.

  // 13.2.5.17 Script data end tag name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
  // U+002F SOLIDUS (/)
  // If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
  // U+003E GREATER-THAN SIGN (>)
  // If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
  // ASCII lower alpha
  // Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the script data state.

  // 13.2.5.18 Script data escape start state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data escape start dash state. Emit a U+002D HYPHEN-MINUS character token.
  // Anything else
  // Reconsume in the script data state.

  // 13.2.5.19 Script data escape start dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
  // Anything else
  // Reconsume in the script data state.

  // 13.2.5.20 Script data escaped state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data escaped dash state. Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data escaped less-than sign state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.21 Script data escaped dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data escaped less-than sign state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Switch to the script data escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Switch to the script data escaped state. Emit the current input character as a character token.

  // 13.2.5.22 Script data escaped dash dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data escaped less-than sign state.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the script data state. Emit a U+003E GREATER-THAN SIGN character token.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Switch to the script data escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Switch to the script data escaped state. Emit the current input character as a character token.

  // 13.2.5.23 Script data escaped less-than sign state
  // Consume the next input character:
  // U+002F SOLIDUS (/)
  // Set the temporary buffer to the empty string. Switch to the script data escaped end tag open state.
  // ASCII alpha
  // Set the temporary buffer to the empty string. Emit a U+003C LESS-THAN SIGN character token. Reconsume in the script data double escape start state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token. Reconsume in the script data escaped state.

  // 13.2.5.24 Script data escaped end tag open state
  // Consume the next input character:
  // ASCII alpha
  // Create a new end tag token, set its tag name to the empty string. Reconsume in the script data escaped end tag name state.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the script data escaped state.

  // 13.2.5.25 Script data escaped end tag name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
  // U+002F SOLIDUS (/)
  // If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
  // U+003E GREATER-THAN SIGN (>)
  // If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
  // ASCII lower alpha
  // Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
  // Anything else
  // Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the script data escaped state.

  // 13.2.5.26 Script data double escape start state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // U+002F SOLIDUS (/)
  // U+003E GREATER-THAN SIGN (>)
  // If the temporary buffer is the string "script", then switch to the script data double escaped state. Otherwise, switch to the script data escaped state. Emit the current input character as a character token.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the temporary buffer. Emit the current input character as a character token.
  // ASCII lower alpha
  // Append the current input character to the temporary buffer. Emit the current input character as a character token.
  // Anything else
  // Reconsume in the script data escaped state.

  // 13.2.5.27 Script data double escaped state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data double escaped dash state. Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.

  // 13.2.5.28 Script data double escaped dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the script data double escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Switch to the script data double escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Switch to the script data double escaped state. Emit the current input character as a character token.

  // 13.2.5.29 Script data double escaped dash dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Emit a U+002D HYPHEN-MINUS character token.
  // U+003C LESS-THAN SIGN (<)
  // Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the script data state. Emit a U+003E GREATER-THAN SIGN character token.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Switch to the script data double escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
  // EOF
  // This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
  // Anything else
  // Switch to the script data double escaped state. Emit the current input character as a character token.

  // 13.2.5.30 Script data double escaped less-than sign state
  // Consume the next input character:
  // U+002F SOLIDUS (/)
  // Set the temporary buffer to the empty string. Switch to the script data double escape end state. Emit a U+002F SOLIDUS character token.
  // Anything else
  // Reconsume in the script data double escaped state.

  // 13.2.5.31 Script data double escape end state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // U+002F SOLIDUS (/)
  // U+003E GREATER-THAN SIGN (>)
  // If the temporary buffer is the string "script", then switch to the script data escaped state. Otherwise, switch to the script data double escaped state. Emit the current input character as a character token.
  // ASCII upper alpha
  // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the temporary buffer. Emit the current input character as a character token.
  // ASCII lower alpha
  // Append the current input character to the temporary buffer. Emit the current input character as a character token.
  // Anything else
  // Reconsume in the script data double escaped state.

  // 13.2.5.32 Before attribute name state https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-name-state
  func handleBeforeAttributeNameState() {

    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Ignore the character.
      break

    // U+002F SOLIDUS (/)
    // U+003E GREATER-THAN SIGN (>)
    // EOF
    case "/", ">", nil:
      // Reconsume in the after attribute name state.
      self.reconsume(.afterAttributeName)

    // U+003D EQUALS SIGN (=)
    case "=":
      // This is an unexpected-equals-sign-before-attribute-name parse error.
      // Start a new attribute in the current tag token.
      // Set that attribute's name to the current input character, and its value to the empty string.
      createAttribute(name: String(nextInputCharacter!))

      // Switch to the attribute name state.
      self.state = .attributeName

    // Anything else
    default:
      // Start a new attribute in the current tag token.
      // Set that attribute name and value to the empty string.
      self.createAttribute()

      // Reconsume in the attribute name state.
      self.reconsume(.attributeName)
    }
  }

  // 13.2.5.33 Attribute name state https://html.spec.whatwg.org/multipage/parsing.html#attribute-name-state
  func handleAttributeNameState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    // U+002F SOLIDUS (/)
    // U+003E GREATER-THAN SIGN (>)
    // EOF
    case "\t", "\n", "\u{000C}", " ", "/", ">", nil:
      // Reconsume in the after attribute name state.
      self.reconsume(.afterAttributeName)

    // U+003D EQUALS SIGN (=)
    case "=":
      // Switch to the before attribute value state.
      self.state = .beforeAttributeValue

    // ASCII upper alpha
    case let char where char!.isASCIIUpperAlpha:
      // Append the lowercase version of the current input character (add 0x0020 to the character's code point)
      // to the current attribute's name.
      self.currentAttributeAppendToName(
        String(UnicodeScalar(nextInputCharacter!.unicodeScalars.first!.value + 0x0020)!))

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character
      // to the current attribute's name.
      self.currentAttributeAppendToName("\u{FFFD}")

    // U+0022 QUOTATION MARK (")
    // U+0027 APOSTROPHE (')
    // U+003C LESS-THAN SIGN (<)
    case "\"", "'", "<":
      // This is an unexpected-character-in-attribute-name parse error.
      // Treat it as per the "anything else" entry below.
      fallthrough

    // Anything else
    default:
      // Append the current input character to the current attribute's name.
      self.currentAttributeAppendToName(String(nextInputCharacter!))
    }
  }

  // 13.2.5.34 After attribute name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+002F SOLIDUS (/)
  // Switch to the self-closing start tag state.
  // U+003D EQUALS SIGN (=)
  // Switch to the before attribute value state.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the current tag token.
  // EOF
  // This is an eof-in-tag parse error. Emit an end-of-file token.
  // Anything else
  // Start a new attribute in the current tag token. Set that attribute name and value to the empty string. Reconsume in the attribute name state.

  // 13.2.5.35 Before attribute value state https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-value-state
  func handleBeforeAttributeValueState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Ignore the character.
      break

    // U+0022 QUOTATION MARK (")
    case "\"":
      // Switch to the attribute value (double-quoted) state.
      self.state = .attributeValueDoubleQuoted

    // U+0027 APOSTROPHE (')
    case "'":
      // Switch to the attribute value (single-quoted) state.
      self.state = .attributeValueSingleQuoted

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // This is a missing-attribute-value parse error.
      // Switch to the data state.
      self.state = .data

      // Emit the current tag token.
      self.emitCurrentToken()

    // Anything else
    default:
      // Reconsume in the attribute value (unquoted) state.
      self.reconsume(.attributeValueUnquoted)
    }
  }

  // 13.2.5.36 Attribute value (double-quoted) state https://html.spec.whatwg.org/multipage/parsing.html#attribute-value-(double-quoted)-state
  func handleAttributeValueDoubleQuotedState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0022 QUOTATION MARK (")
    case "\"":
      // Switch to the after attribute value (quoted) state.
      self.state = .afterAttributeValueQuoted

    // U+0026 AMPERSAND (&)
    case "&":
      // Set the return state to the attribute value (double-quoted) state.
      self.returnState = .attributeValueDoubleQuoted

      // Switch to the character reference state.
      self.state = .characterReference

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error.
      // Append a U+FFFD REPLACEMENT CHARACTER character to the current attribute's value.
      self.currentAttributeAppendToValue("\u{FFFD}")

    // EOF
    case nil:
      // This is an eof-in-tag parse error.
      // Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // Append the current input character to the current attribute's value.
      self.currentAttributeAppendToValue(String(nextInputCharacter!))
    }
  }

  // 13.2.5.37 Attribute value (single-quoted) state
  func handleAttributeValueSingleQuotedState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0027 APOSTROPHE (')
    case "'":
      // Switch to the after attribute value (quoted) state.
      self.state = .afterAttributeValueQuoted

    // U+0026 AMPERSAND (&)
    case "&":
      // Set the return state to the attribute value (single-quoted) state.
      // Switch to the character reference state.
      self.returnState = .attributeValueSingleQuoted
      self.state = .characterReference

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error.
      self.currentAttributeAppendToValue("\u{FFFD}")

    // EOF
    case nil:
      // This is an eof-in-tag parse error. Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // Append the current input character to the current attribute's value.
      self.currentAttributeAppendToValue(String(nextInputCharacter!))
    }
  }

  // 13.2.5.38 Attribute value (unquoted) state
  func handleAttributeValueUnquotedState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Switch to the before attribute name state.
      self.state = .beforeAttributeName

    // U+0026 AMPERSAND (&)
    case "&":
      // Set the return state to the attribute value (unquoted) state.
      self.returnState = .attributeValueUnquoted
      // Switch to the character reference state.
      self.state = .characterReference

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state.
      self.state = .data
      // Emit the current tag token.
      self.emitCurrentToken()

    // U+0000 NULL
    // This is an unexpected-null-character parse error.
    case "\0":
      // Append a U+FFFD REPLACEMENT CHARACTER character to the current attribute's value.
      self.currentAttributeAppendToValue("\u{FFFD}")

    // U+0022 QUOTATION MARK (")
    // U+0027 APOSTROPHE (')
    // U+003C LESS-THAN SIGN (<)
    // U+003D EQUALS SIGN (=)
    // U+0060 GRAVE ACCENT (`)
    // This is an unexpected-character-in-unquoted-attribute-value parse error. Treat it as per the "anything else" entry below.
    case "\"", "'", "<", "=", "`":
      print("Unexpected character in unquoted attribute value")
      fallthrough

    // EOF
    case nil:
      // This is an eof-in-tag parse error. Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // Append the current input character to the current attribute's value.
      self.currentAttributeAppendToValue(String(nextInputCharacter!))
    }
  }

  // 13.2.5.39 After attribute value (quoted) state https://html.spec.whatwg.org/multipage/parsing.html#after-attribute-value-(quoted)-state
  func handleAfterAttributeValueQuotedState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Switch to the before attribute name state.
      self.state = .beforeAttributeName

    // U+002F SOLIDUS (/)
    case "/":
      // Switch to the self-closing start tag state.
      self.state = .selfClosingStartTag

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state.
      self.state = .data

      // Emit the current tag token.
      self.emitCurrentToken()

    // EOF
    case nil:
      // This is an eof-in-tag parse error. Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // This is a missing-whitespace-between-attributes parse error. Reconsume in the before attribute name state.
      self.reconsume(.beforeAttributeName)
    }
  }

  // 13.2.5.40 Self-closing start tag state
  // Consume the next input character:
  // U+003E GREATER-THAN SIGN (>)
  // Set the self-closing flag of the current tag token. Switch to the data state. Emit the current tag token.
  // EOF
  // This is an eof-in-tag parse error. Emit an end-of-file token.
  // Anything else
  // This is an unexpected-solidus-in-tag parse error. Reconsume in the before attribute name state.

  // 13.2.5.41 Bogus comment state https://html.spec.whatwg.org/multipage/parsing.html#bogus-comment-state
  func handleBogusCommentState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+003E GREATER-THAN SIGN (>)
    // Switch to the data state. Emit the current comment token.
    case ">":
      self.state = .data
      self.emitCurrentToken()

    // EOF
    // Emit the comment. Emit an end-of-file token.
    case nil:
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // U+0000 NULL
    // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the comment token's data.
    case "\0":
      self.appendCurrenTagTokenName("\u{FFFD}")

    // Anything else
    // Append the current input character to the comment token's data.
    default:
      self.appendCurrenTagTokenName(self.currentInputCharacter()!)
    }
  }

  // 13.2.5.42 Markup declaration open state https://html.spec.whatwg.org/multipage/parsing.html#markup-declaration-open-state
  func handleMarkupDeclarationOpenState() {
    // If the next few characters are:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {
    // U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN (-->)
    case "-":
      if self.data.count > self.position + 1,
        self.data[self.position + 1] == UInt8(ascii: "-")
      {
        // Consume them.
        self.position += 1
        // Create a comment token whose data is the empty string. Switch to the comment start state.
        self.currentToken = .comment("")
        self.state = .commentStart
        return
      }
    case "D", "d":
      // ASCII case-insensitive match for the word "DOCTYPE"
      if self.data.count > self.position + 6,
        self.data[self.position + 1] == UInt8(ascii: "O")
          || self.data[self.position + 1] == UInt8(ascii: "o"),
        self.data[self.position + 2] == UInt8(ascii: "C")
          || self.data[self.position + 2] == UInt8(ascii: "c"),
        self.data[self.position + 3] == UInt8(ascii: "T")
          || self.data[self.position + 3] == UInt8(ascii: "t"),
        self.data[self.position + 4] == UInt8(ascii: "Y")
          || self.data[self.position + 4] == UInt8(ascii: "y"),
        self.data[self.position + 5] == UInt8(ascii: "P")
          || self.data[self.position + 5] == UInt8(ascii: "p"),
        self.data[self.position + 6] == UInt8(ascii: "E")
          || self.data[self.position + 6] == UInt8(ascii: "e")
      {
        // Consume those characters and switch to the DOCTYPE state.
        self.position += 6
        self.state = .doctype
        return
      }

    // The string "[CDATA[" (the five uppercase letters "CDATA" with a U+005B LEFT SQUARE BRACKET character before and after)
    case "[":
      if self.data.count > self.position + 6,
        self.data[self.position + 1] == UInt8(ascii: "C"),
        self.data[self.position + 2] == UInt8(ascii: "D"),
        self.data[self.position + 3] == UInt8(ascii: "A"),
        self.data[self.position + 4] == UInt8(ascii: "T"),
        self.data[self.position + 5] == UInt8(ascii: "A"),
        self.data[self.position + 6] == UInt8(ascii: "[")
      {
        // Consume those characters. If there is an adjusted current node and it is not an element in the HTML namespace,
        // then switch to the CDATA section state. Otherwise, this is a cdata-in-html-content parse error.
        // Create a comment token whose data is the "[CDATA[" string. Switch to the bogus comment state.
        self.position += 6
        // FIXME: if let adjustedCurrentNode = self.adjustedCurrentNode, !adjustedCurrentNode.isHTMLElement() {
        //           self.state = .cdataSection
        self.currentToken = .comment("[CDATA[")
        self.state = .bogusComment
        return
      }

    default:
      break
    }

    // Anything else
    // This is an incorrectly-opened-comment parse error. Create a comment token whose data is the empty string. Switch to the bogus comment state (don't consume anything in the current state).
    self.currentToken = .comment("")
    self.state = .bogusComment
  }

  // 13.2.5.43 Comment start state https://html.spec.whatwg.org/multipage/parsing.html#comment-start-state
  func handleCommentStartState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+002D HYPHEN-MINUS (-)
    case "-":
      // Switch to the comment start dash state.
      self.state = .commentStartDash

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // This is an abrupt-closing-of-empty-comment parse error. Switch to the data state. Emit the current comment token.
      self.state = .data
      self.emitCurrentToken()

    // Anything else
    default:
      // Reconsume in the comment state.
      self.reconsume(.comment)
    }
  }

  // 13.2.5.44 Comment start dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the comment end state.
  // U+003E GREATER-THAN SIGN (>)
  // This is an abrupt-closing-of-empty-comment parse error. Switch to the data state. Emit the current comment token.
  // EOF
  // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
  // Anything else
  // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data. Reconsume in the comment state.

  // 13.2.5.45 Comment state https://html.spec.whatwg.org/multipage/parsing.html#comment-state
  func handleCommentState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+003C LESS-THAN SIGN (<)
    case "<":
      // Append the current input character to the comment token's data. Switch to the comment less-than sign state.
      self.appendCurrenTagTokenName(self.currentInputCharacter()!)
      self.state = .commentLessThanSign

    // U+002D HYPHEN-MINUS (-)
    case "-":
      // Switch to the comment end dash state.
      self.state = .commentEndDash

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the comment token's data.
      self.appendCurrenTagTokenName("\u{FFFD}")

    // EOF
    case nil:
      // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // Anything else
    // Append the current input character to the comment token's data.
    default:
      self.appendCurrenTagTokenName(self.currentInputCharacter()!)
    }
  }

  // 13.2.5.46 Comment less-than sign state
  // Consume the next input character:
  // U+0021 EXCLAMATION MARK (!)
  // Append the current input character to the comment token's data. Switch to the comment less-than sign bang state.
  // U+003C LESS-THAN SIGN (<)
  // Append the current input character to the comment token's data.
  // Anything else
  // Reconsume in the comment state.

  // 13.2.5.47 Comment less-than sign bang state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the comment less-than sign bang dash state.
  // Anything else
  // Reconsume in the comment state.

  // 13.2.5.48 Comment less-than sign bang dash state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Switch to the comment less-than sign bang dash dash state.
  // Anything else
  // Reconsume in the comment end dash state.

  // 13.2.5.49 Comment less-than sign bang dash dash state
  // Consume the next input character:
  // U+003E GREATER-THAN SIGN (>)
  // EOF
  // Reconsume in the comment end state.
  // Anything else
  // This is a nested-comment parse error. Reconsume in the comment end state.

  // 13.2.5.50 Comment end dash state https://html.spec.whatwg.org/multipage/parsing.html#comment-end-dash-state
  func handleCommentEndDashState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+002D HYPHEN-MINUS (-)
    case "-":
      // Switch to the comment end state.
      self.state = .commentEnd

    // EOF
    case nil:
      // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // Anything else
    default:
      // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data. Reconsume in the comment state.
      self.appendCurrenTagTokenName("-")
      self.reconsume(.comment)
    }
  }

  // 13.2.5.51 Comment end state https://html.spec.whatwg.org/multipage/parsing.html#comment-end-state
  func handleCommentEndState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+003E GREATER-THAN SIGN (>)
    // Switch to the data state. Emit the current comment token.
    case ">":
      self.state = .data
      self.emitCurrentToken()

    // U+0021 EXCLAMATION MARK (!)
    // Switch to the comment end bang state.
    case "!":
      self.state = .commentEndBang

    // U+002D HYPHEN-MINUS (-)
    // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data.
    case "-":
      self.appendCurrenTagTokenName("-")

    // EOF
    // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
    case nil:
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // Anything else
    // Append two U+002D HYPHEN-MINUS characters (-) to the comment token's data. Reconsume in the comment state.
    default:
      self.appendCurrenTagTokenName("-")
      self.appendCurrenTagTokenName("-")
      self.reconsume(.comment)
    }
  }

  // 13.2.5.52 Comment end bang state
  // Consume the next input character:
  // U+002D HYPHEN-MINUS (-)
  // Append two U+002D HYPHEN-MINUS characters (-) and a U+0021 EXCLAMATION MARK character (!) to the comment token's data. Switch to the comment end dash state.
  // U+003E GREATER-THAN SIGN (>)
  // This is an incorrectly-closed-comment parse error. Switch to the data state. Emit the current comment token.
  // EOF
  // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
  // Anything else
  // Append two U+002D HYPHEN-MINUS characters (-) and a U+0021 EXCLAMATION MARK character (!) to the comment token's data. Reconsume in the comment state.

  // 13.2.5.53 DOCTYPE state https://html.spec.whatwg.org/multipage/parsing.html#doctype-state
  func handleDoctypeState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    // Switch to the before DOCTYPE name state.
    case "\u{0009}", "\u{000A}", "\u{000C}", " ":
      self.state = .beforeDoctypeName

    // U+003E GREATER-THAN SIGN (>)
    // Reconsume in the before DOCTYPE name state.
    case ">":
      self.reconsume(.beforeDoctypeName)

    // EOF
    case nil:
      // This is an eof-in-doctype parse error. Create a new DOCTYPE token. Set its force-quirks flag to on.
      self.currentToken = .doctype(name: "", publicId: nil, systemId: nil, forceQuirks: true)
      // Emit the current token.
      self.emitCurrentToken()
      // Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // This is a missing-whitespace-before-doctype-name parse error.
      // Reconsume in the before DOCTYPE name state.
      self.reconsume(.beforeDoctypeName)
    }
  }

  // 13.2.5.54 Before DOCTYPE name state https://html.spec.whatwg.org/multipage/parsing.html#before-doctype-name-state
  func handleBeforeDoctypeNameState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    // Ignore the character.
    case "\u{0009}", "\u{000A}", "\u{000C}", " ":
      break

    // ASCII upper alpha
    case let character where character!.isASCIIUpperAlpha:
      // Create a new DOCTYPE token. Set the token's name to the lowercase
      // version of the current input character (add 0x0020 to the character's
      // code point). 
      self.currentToken = .doctype(
        name: character!.lowercased(), publicId: nil, systemId: nil, forceQuirks: false)
      // Switch to the DOCTYPE name state.
      self.state = .doctypeName

    // U+0000 NULL
    case "\u{0000}":
      // This is an unexpected-null-character parse error. Create a new DOCTYPE token. 
      // Set the token's name to a U+FFFD REPLACEMENT CHARACTER character. 
      self.currentToken = .doctype(
        name: "\u{FFFD}", publicId: nil, systemId: nil, forceQuirks: false)
      // Switch to the DOCTYPE name state.
      self.state = .doctypeName

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // This is a missing-doctype-name parse error. Create a new DOCTYPE token.
      // Set its force-quirks flag to on. Switch to the data state. Emit the
      // current token.
      self.currentToken = .doctype(name: "", publicId: nil, systemId: nil, forceQuirks: true)
      self.state = .data
      self.emitCurrentToken()

    // EOF
    case nil:
      // This is an eof-in-doctype parse error. Create a new DOCTYPE token. Set
      // its force-quirks flag to on. Emit the current token. Emit an end-of-file
      // token.
      self.currentToken = .doctype(name: "", publicId: nil, systemId: nil, forceQuirks: true)
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // Anything else
    case let character:
      // Create a new DOCTYPE token. Set the token's name to the current input
      // character. Switch to the DOCTYPE name state.
      self.currentToken = .doctype(
        name: String(character!), publicId: nil, systemId: nil, forceQuirks: false)
      self.state = .doctypeName
    }
  }

  // 13.2.5.55 DOCTYPE name state https://html.spec.whatwg.org/multipage/parsing.html#doctype-name-state
  func handleDoctypeNameState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\u{0009}", "\u{000A}", "\u{000C}", " ":
      // Switch to the after DOCTYPE name state.
      self.state = .afterDoctypeName

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state. Emit the current DOCTYPE token.
      self.state = .data
      self.emitCurrentToken()

    // ASCII upper alpha
    case let character where character!.isASCIIUpperAlpha:
      // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current DOCTYPE token's name.
      self.currentDocTypeAppendToName(character!.lowercased())

    // U+0000 NULL
    case "\u{0000}":
      // This is an unexpected-null-character parse error.
      // Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's name.
      self.currentDocTypeAppendToName("\u{FFFD}")

    // EOF
    case nil:
      // This is an eof-in-doctype parse error.
      // Set the current DOCTYPE token's force-quirks flag to on.
      self.currentDocTypeSetForceQuirksFlag(true)
      // Emit the current DOCTYPE token.
      self.emitCurrentToken()
      // Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    // Append the current input character to the current DOCTYPE token's name.
    case let character:
      self.currentDocTypeAppendToName(String(character!))
    }
  }

  // 13.2.5.56 After DOCTYPE name state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // If the six characters starting from the current input character are an ASCII case-insensitive match for the word "PUBLIC", then consume those characters and switch to the after DOCTYPE public keyword state.
  // Otherwise, if the six characters starting from the current input character are an ASCII case-insensitive match for the word "SYSTEM", then consume those characters and switch to the after DOCTYPE system keyword state.
  // Otherwise, this is an invalid-character-sequence-after-doctype-name parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.57 After DOCTYPE public keyword state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Switch to the before DOCTYPE public identifier state.
  // U+0022 QUOTATION MARK (")
  // This is a missing-whitespace-after-doctype-public-keyword parse error. Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // This is a missing-whitespace-after-doctype-public-keyword parse error. Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (single-quoted) state.
  // U+003E GREATER-THAN SIGN (>)
  // This is a missing-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.58 Before DOCTYPE public identifier state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+0022 QUOTATION MARK (")
  // Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (single-quoted) state.
  // U+003E GREATER-THAN SIGN (>)
  // This is a missing-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.59 DOCTYPE public identifier (double-quoted) state
  // Consume the next input character:
  // U+0022 QUOTATION MARK (")
  // Switch to the after DOCTYPE public identifier state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's public identifier.
  // U+003E GREATER-THAN SIGN (>)
  // This is an abrupt-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // Append the current input character to the current DOCTYPE token's public identifier.

  // 13.2.5.60 DOCTYPE public identifier (single-quoted) state
  // Consume the next input character:
  // U+0027 APOSTROPHE (')
  // Switch to the after DOCTYPE public identifier state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's public identifier.
  // U+003E GREATER-THAN SIGN (>)
  // This is an abrupt-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // Append the current input character to the current DOCTYPE token's public identifier.

  // 13.2.5.61 After DOCTYPE public identifier state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Switch to the between DOCTYPE public and system identifiers state.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the current DOCTYPE token.
  // U+0022 QUOTATION MARK (")
  // This is a missing-whitespace-between-doctype-public-and-system-identifiers parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // This is a missing-whitespace-between-doctype-public-and-system-identifiers parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.62 Between DOCTYPE public and system identifiers state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the current DOCTYPE token.
  // U+0022 QUOTATION MARK (")
  // Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.63 After DOCTYPE system keyword state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Switch to the before DOCTYPE system identifier state.
  // U+0022 QUOTATION MARK (")
  // This is a missing-whitespace-after-doctype-system-keyword parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // This is a missing-whitespace-after-doctype-system-keyword parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
  // U+003E GREATER-THAN SIGN (>)
  // This is a missing-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.64 Before DOCTYPE system identifier state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+0022 QUOTATION MARK (")
  // Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
  // U+0027 APOSTROPHE (')
  // Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
  // U+003E GREATER-THAN SIGN (>)
  // This is a missing-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

  // 13.2.5.65 DOCTYPE system identifier (double-quoted) state
  // Consume the next input character:
  // U+0022 QUOTATION MARK (")
  // Switch to the after DOCTYPE system identifier state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's system identifier.
  // U+003E GREATER-THAN SIGN (>)
  // This is an abrupt-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // Append the current input character to the current DOCTYPE token's system identifier.

  // 13.2.5.66 DOCTYPE system identifier (single-quoted) state
  // Consume the next input character:
  // U+0027 APOSTROPHE (')
  // Switch to the after DOCTYPE system identifier state.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's system identifier.
  // U+003E GREATER-THAN SIGN (>)
  // This is an abrupt-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // Append the current input character to the current DOCTYPE token's system identifier.

  // 13.2.5.67 After DOCTYPE system identifier state
  // Consume the next input character:
  // U+0009 CHARACTER TABULATION (tab)
  // U+000A LINE FEED (LF)
  // U+000C FORM FEED (FF)
  // U+0020 SPACE
  // Ignore the character.
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the current DOCTYPE token.
  // EOF
  // This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // This is an unexpected-character-after-doctype-system-identifier parse error. Reconsume in the bogus DOCTYPE state. (This does not set the current DOCTYPE token's force-quirks flag to on.)

  // 13.2.5.68 Bogus DOCTYPE state
  // Consume the next input character:
  // U+003E GREATER-THAN SIGN (>)
  // Switch to the data state. Emit the DOCTYPE token.
  // U+0000 NULL
  // This is an unexpected-null-character parse error. Ignore the character.
  // EOF
  // Emit the DOCTYPE token. Emit an end-of-file token.
  // Anything else
  // Ignore the character.

  // 13.2.5.69 CDATA section state
  // Consume the next input character:
  // U+005D RIGHT SQUARE BRACKET (])
  // Switch to the CDATA section bracket state.
  // EOF
  // This is an eof-in-cdata parse error. Emit an end-of-file token.
  // Anything else
  // Emit the current input character as a character token.
  // U+0000 NULL characters are handled in the tree construction stage, as part of the in foreign content insertion mode, which is the only place where CDATA sections can appear.

  // 13.2.5.70 CDATA section bracket state
  // Consume the next input character:
  // U+005D RIGHT SQUARE BRACKET (])
  // Switch to the CDATA section end state.
  // Anything else
  // Emit a U+005D RIGHT SQUARE BRACKET character token. Reconsume in the CDATA section state.

  // 13.2.5.71 CDATA section end state
  // Consume the next input character:
  // U+005D RIGHT SQUARE BRACKET (])
  // Emit a U+005D RIGHT SQUARE BRACKET character token.
  // U+003E GREATER-THAN SIGN character
  // Switch to the data state.
  // Anything else
  // Emit two U+005D RIGHT SQUARE BRACKET character tokens. Reconsume in the CDATA section state.

  // 13.2.5.72 Character reference state https://html.spec.whatwg.org/multipage/parsing.html#character-reference-state
  func handleCharacterReferenceState() {
    // Set the temporary buffer to the empty string.
    // Append a U+0026 AMPERSAND (&) character to the temporary buffer.
    self.temporaryBuffer = "&"

    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()

    switch nextInputCharacter {

    // ASCII alphanumeric
    case let char where char?.isASCIIAlphanumeric == true:
      // Reconsume in the named character reference state.
      self.reconsume(.namedCharacterReference)

    // U+0023 NUMBER SIGN (#)
    case "#":
      // Append the current input character to the temporary buffer. Switch to the numeric character reference state.
      temporaryBuffer.append("#")
      self.state = .numericCharacterReference

    // Anything else
    default:
      // Flush code points consumed as a character reference.
      self.flushCodePointsConsumedAsCharacterReference()

      // Reconsume in the return state.
      self.reconsume(self.returnState)
    }
  }

  // 13.2.5.73 Named character reference state
  // Consume the maximum number of characters possible, where the consumed characters are one of the identifiers in the first column of the named character references table. Append each character to the temporary buffer when it's consumed.
  // If there is a match
  // If the character reference was consumed as part of an attribute, and the last character matched is not a U+003B SEMICOLON character (;), and the next input character is either a U+003D EQUALS SIGN character (=) or an ASCII alphanumeric, then, for historical reasons, flush code points consumed as a character reference and switch to the return state.
  // Otherwise:
  // If the last character matched is not a U+003B SEMICOLON character (;), then this is a missing-semicolon-after-character-reference parse error.
  // Set the temporary buffer to the empty string. Append one or two characters corresponding to the character reference name (as given by the second column of the named character references table) to the temporary buffer.
  // Flush code points consumed as a character reference. Switch to the return state.
  // Otherwise
  // Flush code points consumed as a character reference. Switch to the ambiguous ampersand state.
  // If the markup contains (not in an attribute) the string I'm &notit; I tell you, the character reference is parsed as "not", as in, I'm ¬it; I tell you (and this is a parse error). But if the markup was I'm &notin; I tell you, the character reference would be parsed as "notin;", resulting in I'm ∉ I tell you (and no parse error).
  // However, if the markup contains the string I'm &notit; I tell you in an attribute, no character reference is parsed and string remains intact (and there is no parse error).

  // 13.2.5.74 Ambiguous ampersand state
  // Consume the next input character:
  // ASCII alphanumeric
  // If the character reference was consumed as part of an attribute, then append the current input character to the current attribute's value. Otherwise, emit the current input character as a character token.
  // U+003B SEMICOLON (;)
  // This is an unknown-named-character-reference parse error. Reconsume in the return state.
  // Anything else
  // Reconsume in the return state.

  // 13.2.5.75 Numeric character reference state
  // Set the character reference code to zero (0).
  // Consume the next input character:
  // U+0078 LATIN SMALL LETTER X
  // U+0058 LATIN CAPITAL LETTER X
  // Append the current input character to the temporary buffer. Switch to the hexadecimal character reference start state.
  // Anything else
  // Reconsume in the decimal character reference start state.

  // 13.2.5.76 Hexadecimal character reference start state
  // Consume the next input character:
  // ASCII hex digit
  // Reconsume in the hexadecimal character reference state.
  // Anything else
  // This is an absence-of-digits-in-numeric-character-reference parse error. Flush code points consumed as a character reference. Reconsume in the return state.

  // 13.2.5.77 Decimal character reference start state
  // Consume the next input character:
  // ASCII digit
  // Reconsume in the decimal character reference state.
  // Anything else
  // This is an absence-of-digits-in-numeric-character-reference parse error. Flush code points consumed as a character reference. Reconsume in the return state.

  // 13.2.5.78 Hexadecimal character reference state
  // Consume the next input character:

  // ASCII digit
  // Multiply the character reference code by 16. Add a numeric version of the current input character (subtract 0x0030 from the character's code point) to the character reference code.
  // ASCII upper hex digit
  // Multiply the character reference code by 16. Add a numeric version of the current input character as a hexadecimal digit (subtract 0x0037 from the character's code point) to the character reference code.
  // ASCII lower hex digit
  // Multiply the character reference code by 16. Add a numeric version of the current input character as a hexadecimal digit (subtract 0x0057 from the character's code point) to the character reference code.
  // U+003B SEMICOLON
  // Switch to the numeric character reference end state.
  // Anything else
  // This is a missing-semicolon-after-character-reference parse error. Reconsume in the numeric character reference end state.

  // 13.2.5.79 Decimal character reference state
  // Consume the next input character:
  // ASCII digit
  // Multiply the character reference code by 10. Add a numeric version of the current input character (subtract 0x0030 from the character's code point) to the character reference code.
  // U+003B SEMICOLON
  // Switch to the numeric character reference end state.
  // Anything else
  // This is a missing-semicolon-after-character-reference parse error. Reconsume in the numeric character reference end state.

  // 13.2.5.80 Numeric character reference end state
  // Check the character reference code:
  // If the number is 0x00, then this is a null-character-reference parse error. Set the character reference code to 0xFFFD.
  // If the number is greater than 0x10FFFF, then this is a character-reference-outside-unicode-range parse error. Set the character reference code to 0xFFFD.
  // If the number is a surrogate, then this is a surrogate-character-reference parse error. Set the character reference code to 0xFFFD.
  // If the number is a noncharacter, then this is a noncharacter-character-reference parse error.
  // If the number is 0x0D, or a control that's not ASCII whitespace, then this is a control-character-reference parse error. If the number is one of the numbers in the first column of the following table, then find the row with that number in the first column, and set the character reference code to the number in the second column of that row.
  // Number	Code point
  // 0x80	0x20AC	EURO SIGN (€)
  // 0x82	0x201A	SINGLE LOW-9 QUOTATION MARK (‚)
  // 0x83	0x0192	LATIN SMALL LETTER F WITH HOOK (ƒ)
  // 0x84	0x201E	DOUBLE LOW-9 QUOTATION MARK („)
  // 0x85	0x2026	HORIZONTAL ELLIPSIS (…)
  // 0x86	0x2020	DAGGER (†)
  // 0x87	0x2021	DOUBLE DAGGER (‡)
  // 0x88	0x02C6	MODIFIER LETTER CIRCUMFLEX ACCENT (ˆ)
  // 0x89	0x2030	PER MILLE SIGN (‰)
  // 0x8A	0x0160	LATIN CAPITAL LETTER S WITH CARON (Š)
  // 0x8B	0x2039	SINGLE LEFT-POINTING ANGLE QUOTATION MARK (‹)
  // 0x8C	0x0152	LATIN CAPITAL LIGATURE OE (Œ)
  // 0x8E	0x017D	LATIN CAPITAL LETTER Z WITH CARON (Ž)
  // 0x91	0x2018	LEFT SINGLE QUOTATION MARK (‘)
  // 0x92	0x2019	RIGHT SINGLE QUOTATION MARK (’)
  // 0x93	0x201C	LEFT DOUBLE QUOTATION MARK (“)
  // 0x94	0x201D	RIGHT DOUBLE QUOTATION MARK (”)
  // 0x95	0x2022	BULLET (•)
  // 0x96	0x2013	EN DASH (–)
  // 0x97	0x2014	EM DASH (—)
  // 0x98	0x02DC	SMALL TILDE (˜)
  // 0x99	0x2122	TRADE MARK SIGN (™)
  // 0x9A	0x0161	LATIN SMALL LETTER S WITH CARON (š)
  // 0x9B	0x203A	SINGLE RIGHT-POINTING ANGLE QUOTATION MARK (›)
  // 0x9C	0x0153	LATIN SMALL LIGATURE OE (œ)
  // 0x9E	0x017E	LATIN SMALL LETTER Z WITH CARON (ž)
  // 0x9F	0x0178	LATIN CAPITAL LETTER Y WITH DIAERESIS (Ÿ)
  // Set the temporary buffer to the empty string. Append a code point equal to the character reference code to the temporary buffer. Flush code points consumed as a character reference. Switch to the return state.

}
