  extension Tokenizer {
    
  // 13.2.5.7 End tag open state 
  // https://html.spec.whatwg.org/multipage/parsing.html#end-tag-open-state
  func handleEndTagOpenState() {
    
    // Consume the next input character:
    switch consumeNextInputCharacter() {

    // ASCII alpha
    // Create a new end tag token, set its tag name to the empty string. Reconsume in the tag name state.
    case let char where char!.isLetter:
      currentToken = .endTag("")
      reconsume(.tagName)

    // U+003E GREATER-THAN SIGN (>)
    // This is a missing-end-tag-name parse error. Switch to the data state.
    case ">":
      state = .data

    // EOF
    // This is an eof-before-tag-name parse error. Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token and an end-of-file token.
    case nil:
      emitCharacterToken("<")
      emitCharacterToken("/")
      emitEndOfFileToken()

    // Anything else
    // This is an invalid-first-character-of-tag-name parse error. Create a comment token whose data is the empty string. Reconsume in the bogus comment state.
    default:
      currentToken = .comment("")
      reconsume(.bogusComment)
    }
  }

}