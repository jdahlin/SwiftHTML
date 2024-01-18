extension Tokenizer {
  
    // 13.2.5.53 DOCTYPE state https://html.spec.whatwg.org/multipage/parsing.html#doctype-state
  func handleDoctypeState() {
    // Consume the next input character:
    let nextInputCharacter = self.consumeNextInputCharacter()
    switch nextInputCharacter {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    // Switch to the before DOCTYPE name state.
    case "\u{0009}", "\u{000A}", "\u{000C}", " ":
      self.state = .beforeDoctypeName

    // U+003E GREATER-THAN SIGN (>)
    // Reconsume in the before DOCTYPE name state.
    case ">":
      self.reconsume(.beforeDoctypeName)

    // EOF
    case nil:
      // This is an eof-in-doctype parse error. Create a new DOCTYPE token. Set its force-quirks flag to on.
      self.currentToken = .doctype(name: "", publicId: nil, systemId: nil, forceQuirks: true)
      // Emit the current token.
      self.emitCurrentToken()
      // Emit an end-of-file token.
      self.emitEndOfFileToken()

    // Anything else
    default:
      // This is a missing-whitespace-before-doctype-name parse error.
      // Reconsume in the before DOCTYPE name state.
      self.reconsume(.beforeDoctypeName)
    }
  }

}