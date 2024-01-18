extension Tokenizer {

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

}