extension Tokenizer {
  
  // 13.2.5.39 After attribute value (quoted) state 
  // https://html.spec.whatwg.org/multipage/parsing.html#after-attribute-value-(quoted)-state
  func handleAfterAttributeValueQuotedState() {
    
    // Consume the next input character:
    switch consumeNextInputCharacter() {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Switch to the before attribute name state.
      state = .beforeAttributeName

    // U+002F SOLIDUS (/)
    case "/":
      // Switch to the self-closing start tag state.
      state = .selfClosingStartTag

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state.
      state = .data

      // Emit the current tag token.
      emitCurrentToken()

    // EOF
    case nil:
      // This is an eof-in-tag parse error. Emit an end-of-file token.
      emitEndOfFileToken()

    // Anything else
    default:
      // This is a missing-whitespace-between-attributes parse error. Reconsume in the before attribute name state.
      reconsume(.beforeAttributeName)
    }
  }

}