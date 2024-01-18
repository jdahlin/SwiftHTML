extension Tokenizer {

  // 13.2.5.50 Comment end dash state
  // https://html.spec.whatwg.org/multipage/parsing.html#comment-end-dash-state
  func handleCommentEndDashState() {
    
    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

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

}
