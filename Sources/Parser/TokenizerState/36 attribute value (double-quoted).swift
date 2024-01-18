extension Tokenizer {
  
  // 13.2.5.36 Attribute value (double-quoted) state
  //  https://html.spec.whatwg.org/multipage/parsing.html#attribute-value-(double-quoted)-state
  func handleAttributeValueDoubleQuotedState() {
    
    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

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
      self.currentAttributeAppendToValue(String(self.currentInputCharacter()!))
    }
  }

}