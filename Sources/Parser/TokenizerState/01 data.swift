extension Tokenizer {

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

}
