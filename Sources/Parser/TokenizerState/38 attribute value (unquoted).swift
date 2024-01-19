extension Tokenizer {
  
  // 13.2.5.38 Attribute value (unquoted) state
  // https://html.spec.whatwg.org/multipage/parsing.html#attribute-value-(unquoted)-state
  func handleAttributeValueUnquotedState() {
    
    // Consume the next input character:
    switch consumeNextInputCharacter() {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    case "\t", "\n", "\u{000C}", " ":
      // Switch to the before attribute name state.
      state = .beforeAttributeName

    // U+0026 AMPERSAND (&)
    case "&":
      // Set the return state to the attribute value (unquoted) state.
      returnState = .attributeValueUnquoted
      // Switch to the character reference state.
      state = .characterReference

    // U+003E GREATER-THAN SIGN (>)
    case ">":
      // Switch to the data state.
      state = .data
      // Emit the current tag token.
      emitCurrentToken()

    // U+0000 NULL
    // This is an unexpected-null-character parse error.
    case "\0":
      // Append a U+FFFD REPLACEMENT CHARACTER character to the current attribute's value.
      currentAttributeAppendToValue("\u{FFFD}")

    // U+0022 QUOTATION MARK (")
    // U+0027 APOSTROPHE (')
    // U+003C LESS-THAN SIGN (<)
    // U+003D EQUALS SIGN (=)
    // U+0060 GRAVE ACCENT (`)
    // This is an unexpected-character-in-unquoted-attribute-value parse error. Treat it as per the "anything else" entry below.
    case "\"", "'", "<", "=", "`":
      print("Unexpected character in unquoted attribute value")
      fallthrough

    // EOF
    case nil:
      // This is an eof-in-tag parse error. Emit an end-of-file token.
      emitEndOfFileToken()

    // Anything else
    default:
      // Append the current input character to the current attribute's value.
      currentAttributeAppendToValue(String(currentInputCharacter()!))
    }
  }

}