extension Tokenizer {

  // 13.2.5.72 Character reference state 
  // https://html.spec.whatwg.org/multipage/parsing.html#character-reference-state
  func handleCharacterReferenceState() {
    
    // Set the temporary buffer to the empty string.
    // Append a U+0026 AMPERSAND (&) character to the temporary buffer.
    self.temporaryBuffer = "&"

    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

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

}