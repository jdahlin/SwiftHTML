extension Tokenizer {
  
  // 13.2.5.41 Bogus comment state 
  // https://html.spec.whatwg.org/multipage/parsing.html#bogus-comment-state
  func handleBogusCommentState() {
    
    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

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

}