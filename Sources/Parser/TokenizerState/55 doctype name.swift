extension Tokenizer {

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

}
