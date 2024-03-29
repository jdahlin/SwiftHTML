import Foundation

extension Character {
    // https://infra.spec.whatwg.org/#ascii-alphanumeric
    // An ASCII digit is a code point in the range U+0030 (0) to U+0039 (9), inclusive.
    var isASCIIDigit: Bool {
        "0" ... "9" ~= self
    }

    // An ASCII upper hex digit is an ASCII digit or a code point in the range U+0041 (A) to U+0046 (F), inclusive.
    var isASCIIUpperHexDigit: Bool {
        isASCIIDigit || "A" ... "F" ~= self
    }

    // An ASCII lower hex digit is an ASCII digit or a code point in the range U+0061 (a) to U+0066 (f), inclusive.
    var isASCIILowerHexDigit: Bool {
        isASCIIDigit || "a" ... "f" ~= self
    }

    // An ASCII hex digit is an ASCII upper hex digit or ASCII lower hex digit.
    var isASCIIHexDigit: Bool {
        isASCIIUpperHexDigit || isASCIILowerHexDigit
    }

    // An ASCII upper alpha is a code point in the range U+0041 (A) to U+005A (Z), inclusive.
    var isASCIIUpperAlpha: Bool {
        "A" ... "Z" ~= self
    }

    // An ASCII lower alpha is a code point in the range U+0061 (a) to U+007A (z), inclusive.
    var isASCIILowerAlpha: Bool {
        "a" ... "z" ~= self
    }

    // An ASCII alpha is an ASCII upper alpha or ASCII lower alpha.
    var isASCIIAlpha: Bool {
        isASCIIUpperAlpha || isASCIILowerAlpha
    }

    // An ASCII alphanumeric is an ASCII digit or ASCII alpha.
    var isASCIIAlphanumeric: Bool {
        isASCIIDigit || isASCIIAlpha
    }
}

protocol TokenReceiver {
    func didReceiveToken(_ token: HTML.Token)
}

extension HTML {
    struct ByteStream {
        var position: Int = 0
        var data: Data
    }

    // https://infra.spec.whatwg.org/#normalize-newlines

    static func normalizeNewlines(_ data: inout Data) {
        // in a string, replace every U+000D CR U+000A LF code point pair with a single U+000A LF code point, and then replace every remaining U+000D CR code point with a U+000A LF code point.
        var currentIndex = data.startIndex
        while currentIndex < data.endIndex {
            if currentIndex < data.index(before: data.endIndex),
               data[currentIndex] == 0x0D,
               data[data.index(after: currentIndex)] == 0x0A
            {
                // Replace U+000D CR U+000A LF code point pair with a single U+000A LF code point
                data.replaceSubrange(currentIndex ..< data.index(currentIndex, offsetBy: 2), with: [0x0A])
                currentIndex = data.index(after: currentIndex)
            } else if data[currentIndex] == 0x0D {
                // Replace standalone U+000D CR with U+000A LF code point
                data[currentIndex] = 0x0A
            }
            currentIndex = data.index(after: currentIndex)
        }
    }

    enum TokenizerState {
        case data
        case rcData
        case plaintext
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
        case scriptDataLessThanSign
        case scriptDataEndTagOpen
        case scriptDataEndTagName
        case scriptDataEscapeStart
        case scriptDataEscapeStartDash
        case scriptDataEscape
        case scriptDataEscapeDash
        case scriptDataEscapeDashDash
        case scriptDataEscapeLessThanSign
        case scriptDataEscapeEndTagOpen
        case scriptDataEscapeEndTagName
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

    struct TokenizerTag {
        var name: String
        var attributes: [TokenizerAttr] = []
        var isSelfClosing: Bool = false
    }

    struct TokenizerAttr {
        var name: String
        var value: String
    }

    struct DocType {
        var name: String?
        var publicIdentifier: String?
        var systemIdentifier: String?
        var forceQuirks: Bool = false
    }

    struct Comment {
        var data: String
    }

    enum Token {
        case character(Character)
        case startTag(TokenizerTag)
        case endTag(TokenizerTag)
        case comment(Comment)
        case doctype(DocType)
        case attribute(name: String, value: String)
        case eof
    }

    typealias EmitFunc = (Token) -> Void

    class Tokenizer {
        var position = -1
        var data: Data
        var state: TokenizerState = .data
        var returnState: TokenizerState = .data
        var delegate: TokenReceiver?
        var currentToken: HTML.Token?
        var reconsumeNext = false
        var temporaryBuffer = ""
        var currentEndTagName: String?
        var lastStartTagName: String?
        lazy var currentDocTypeToken: DocType = .init()
        lazy var currentCommentToken: Comment = .init(data: "")

        init(data: Data) {
            self.data = data
        }

        func isEOF() -> Bool {
            data.count <= position
        }

        func consumeNextInputCharacter() -> Character? {
            if reconsumeNext {
                reconsumeNext = false
            } else {
                position += 1
            }
            let char = currentInputCharacter()
            return char
        }

        func currentInputCharacter() -> Character? {
            if isEOF() {
                return nil
            }

            return Character(UnicodeScalar(data[position]))
        }

        func emitToken(_ token: HTML.Token) {
            switch token {
            case let .startTag(tag):
                lastStartTagName = tag.name
            case let .endTag(tag):
                currentEndTagName = tag.name
            default:
                break
            }
            delegate?.didReceiveToken(token)
        }

        func emitCharacterToken(_ character: Character) {
            emitToken(.character(character))
        }

        func emitEndOfFileToken() {
            emitToken(.eof)
        }

        func emitCurrentDocTypeToken() {
            guard case .doctype = currentToken else {
                fatalError("Expected current token to be a doctype, not \(currentToken.debugDescription)")
            }
            emitCurrentToken()
        }

        func emitCurrentToken(expectedToken _: Token? = nil) {
            guard let token = currentToken else {
                assertionFailure()
                return
            }
            emitToken(token)
        }

        func isCurrentEndTagTokenAppropriateEndTagToken() -> Bool {
            if lastStartTagName == nil {
                return false
            }
            // FIXME: Confirm that this is correct or just coincidencially works
            return temporaryBuffer == lastStartTagName
        }

        func createDocTypeToken() {
            currentDocTypeToken = .init()
            currentToken = .doctype(currentDocTypeToken)
        }

        func createAttribute(name: String = "", value: String = "") {
            switch currentToken {
            case let .startTag(tag):
                currentToken = .startTag(TokenizerTag(
                    name: tag.name,
                    attributes: tag.attributes + [TokenizerAttr(name: name, value: value)],
                    isSelfClosing: tag.isSelfClosing
                ))
            default:
                assertionFailure()
                exit(0)
            }
        }

        func currentAttributeAppendToName(_ name: String) {
            guard case var .startTag(tag) = currentToken else {
                assertionFailure()
                return
            }

            if let lastAttribute = tag.attributes.last {
                tag.attributes[tag.attributes.count - 1] = TokenizerAttr(
                    name: lastAttribute.name + name, value: lastAttribute.value
                )
            }

            currentToken = .startTag(TokenizerTag(
                name: tag.name,
                attributes: tag.attributes,
                isSelfClosing: tag.isSelfClosing
            ))
        }

        func currentAttributeAppendToValue(_ value: String) {
            switch currentToken {
            case var .startTag(tag):
                if let lastAttribute = tag.attributes.last {
                    tag.attributes[tag.attributes.count - 1] = TokenizerAttr(
                        name: lastAttribute.name, value: lastAttribute.value + value
                    )
                }
                currentToken = .startTag(TokenizerTag(
                    name: tag.name,
                    attributes: tag.attributes,
                    isSelfClosing: tag.isSelfClosing
                ))
            default:
                assertionFailure()
                return
            }
        }

        func appendCurrenTagTokenName(_ character: Character) {
            switch currentToken {
            case var .startTag(tag):
                tag.name.append(character)
                currentToken = .startTag(tag)
            case var .endTag(tag):
                tag.name.append(character)
                currentToken = .endTag(tag)
            default:
                DIE("Implement me: \(currentToken.debugDescription)")
            }
        }

        func reconsume(_ state: TokenizerState) {
            reconsumeNext = true
            self.state = state
        }

        // https://html.spec.whatwg.org/multipage/parsing.html#flush-code-points-consumed-as-a-character-reference
        func flushCodePointsConsumedAsCharacterReference() {
            // When a state says to flush code points consumed as a character reference, it means that for each code point
            // in the temporary buffer (in the order they were added to the buffer) user agent must append the code point
            // from the buffer to the current attribute's value if the character reference was consumed as part of an attribute,
            //  or emit the code point as a character token otherwise.
            for char in temporaryBuffer {
                if case .attribute = currentToken,
                   [.attributeValueDoubleQuoted, .attributeValueSingleQuoted, .attributeValueUnquoted]
                   .contains(returnState)
                {
                    currentAttributeAppendToValue(String(char))
                } else {
                    emitCharacterToken(char)
                }
            }
        }

        func tokenize() {
            while !isEOF() {
                nextToken()
            }
        }

        func nextToken() {
            switch state {
            // 13.2.5.1 Data state
            case .data:
                handleDataState()

            // 13.2.5.2 RCDATA state
            case .rcData:
                handleRcDataState()

            // 13.2.5.3 RAWTEXT state
            case .rawText:
                handleRawTextState()

            // 13.2.5.4 Script data state
            case .scriptData:
                handleScriptDataState()

            // 13.2.5.5 PLAINTEXT state
            case .plaintext:
                handlePlaintextState()

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
            case .rcDataLessThanSign:
                handleRcDataLessThanSignState()

            // 13.2.5.10 RCDATA end tag open state
            case .rcDataEndTagOpen:
                handleRcDataEndTagOpenState()

            // 13.2.5.11 RCDATA end tag name state
            case .rcDataEndTagName:
                handleRcDataEndTagNameState()

            // 13.2.5.12 RAWTEXT less-than sign state
            case .rawTextLessThanSign:
                handleRawTextLessThanState()

            // 13.2.5.13 RAWTEXT end tag open state
            case .rawTextEndTagOpen:
                handleRawTextEndTagOpenState()

            // 13.2.5.14 RAWTEXT end tag name state
            case .rawTextEndTagName:
                handleRawTextEndTagNameState()

            // 13.2.5.15 Script data less-than sign state
            case .scriptDataLessThanSign:
                handleScriptDataLessThanSignState()

            // 13.2.5.16 Script data end tag open state
            case .scriptDataEndTagOpen:
                handleScriptDataEndTagOpenState()

            // 13.2.5.17 Script data end tag name state
            case .scriptDataEndTagName:
                handleScriptDataEndTagNameState()

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
            case .afterDoctypeName:
                handleAfterDoctypeNameState()

            // 13.2.5.57 After DOCTYPE public keyword state
            case .afterDoctypePublicKeyword:
                handleAfterDoctypePublicKeywordState()

            // 13.2.5.58 Before DOCTYPE public identifier state
            case .beforeDoctypePublicIdentifier:
                handleBeforeDoctypePublicIdentifierState()

            // 13.2.5.59 DOCTYPE identifier (double-quoted) state
            case .doctypePublicIdentifierDoubleQuoted:
                handleDoctypePublicIdentifierDoubleQuotedState()

            // 13.2.5.60 DOCTYPE identifier (single-quoted) state
            // 13.2.5.61 After DOCTYPE identifier state
            // 13.2.5.62 Between DOCTYPE and system identifiers state
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
                DIE("state: \(state) is not implemented")
            }
        }
    }
}
