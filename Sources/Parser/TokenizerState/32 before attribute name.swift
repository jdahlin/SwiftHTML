extension Tokenizer {

  // 13.2.5.32 Before attribute name state 
  // https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-name-state
  func handleBeforeAttributeNameState() {
    
    // Consume the next input character:
    switch consumeNextInputCharacter() {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Ignore the character.
      break

    // U+002F SOLIDUS (/)
    // U+003E GREATER-THAN SIGN (>)
    // EOF
    case "/", ">", nil:
      // Reconsume in the after attribute name state.
      reconsume(.afterAttributeName)

    // U+003D EQUALS SIGN (=)
    case "=":
      // This is an unexpected-equals-sign-before-attribute-name parse error.
      // Start a new attribute in the current tag token.
      // Set that attribute's name to the current input character, and its value to the empty string.
      createAttribute(name: String(currentInputCharacter()!))

      // Switch to the attribute name state.
      state = .attributeName

    // Anything else
    default:
      // Start a new attribute in the current tag token.
      // Set that attribute name and value to the empty string.
      createAttribute()

      // Reconsume in the attribute name state.
      reconsume(.attributeName)
    }
  }
}
