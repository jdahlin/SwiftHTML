extension Tokenizer {

  // 13.2.5.6 Tag open state 
  // https://html.spec.whatwg.org/multipage/parsing.html#tag-open-state
  func handleTagOpenState() {
    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

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

}