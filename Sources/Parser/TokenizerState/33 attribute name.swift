extension Tokenizer {

  // 13.2.5.33 Attribute name state 
  // https://html.spec.whatwg.org/multipage/parsing.html#attribute-name-state
  func handleAttributeNameState() {
    
    // Consume the next input character:
    switch consumeNextInputCharacter() {

    // U+0009 CHARACTER TABULATION (tab)
    // U+000A LINE FEED (LF)
    // U+000C FORM FEED (FF)
    // U+0020 SPACE
    // U+002F SOLIDUS (/)
    // U+003E GREATER-THAN SIGN (>)
    // EOF
    case "\t", "\n", "\u{000C}", " ", "/", ">", nil:
      // Reconsume in the after attribute name state.
      reconsume(.afterAttributeName)

    // U+003D EQUALS SIGN (=)
    case "=":
      // Switch to the before attribute value state.
      state = .beforeAttributeValue

    // ASCII upper alpha
    case let char where char!.isASCIIUpperAlpha:
      // Append the lowercase version of the current input character (add 0x0020 to the character's code point)
      // to the current attribute's name.
      currentAttributeAppendToName(
        String(UnicodeScalar(char!.unicodeScalars.first!.value + 0x0020)!))

    // U+0000 NULL
    case "\0":
      // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character
      // to the current attribute's name.
      currentAttributeAppendToName("\u{FFFD}")

    // U+0022 QUOTATION MARK (")
    // U+0027 APOSTROPHE (')
    // U+003C LESS-THAN SIGN (<)
    case "\"", "'", "<":
      // This is an unexpected-character-in-attribute-name parse error.
      // Treat it as per the "anything else" entry below.
      fallthrough

    // Anything else
    default:
      // Append the current input character to the current attribute's name.
      currentAttributeAppendToName(String(currentInputCharacter()!))
    }
  }

}