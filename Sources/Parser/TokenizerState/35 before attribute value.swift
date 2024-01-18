extension Tokenizer {

  // 13.2.5.35 Before attribute value state 
  // https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-value-state
  func handleBeforeAttributeValueState() {
    
    // Consume the next input character:
    switch self.consumeNextInputCharacter() {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Ignore the character.
      break

    // U+0022 QUOTATION MARK (")
    case "\"":
      // Switch to the attribute value (double-quoted) state.
      self.state = .attributeValueDoubleQuoted

    // U+0027 APOSTROPHE (')
    case "'":
      // Switch to the attribute value (single-quoted) state.
      self.state = .attributeValueSingleQuoted

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // This is a missing-attribute-value parse error.
      // Switch to the data state.
      self.state = .data

      // Emit the current tag token.
      self.emitCurrentToken()

    // Anything else
    default:
      // Reconsume in the attribute value (unquoted) state.
      self.reconsume(.attributeValueUnquoted)
    }
  }

}