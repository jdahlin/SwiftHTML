extension Tokenizer {
  
    // 13.2.5.45 Comment state https://html.spec.whatwg.org/multipage/parsing.html#comment-state
  func handleCommentState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+003C LESS-THAN SIGN (<)
    case "<":
      // Append the current input character to the comment token's data. Switch to the comment less-than sign state.
      self.appendCurrenTagTokenName(self.currentInputCharacter()!)
      self.state = .commentLessThanSign

    // U+002D HYPHEN-MINUS (-)
    case "-":
      // Switch to the comment end dash state.
      self.state = .commentEndDash

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the comment token's data.
      self.appendCurrenTagTokenName("\u{FFFD}")

    // EOF
    case nil:
      // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
      self.emitCurrentToken()
      self.emitEndOfFileToken()

    // Anything else
    // Append the current input character to the comment token's data.
    default:
      self.appendCurrenTagTokenName(self.currentInputCharacter()!)
    }
  }

}