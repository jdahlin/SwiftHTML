extension HTML.Tokenizer {
    // 13.2.5.42 Markup declaration open state
    // https://html.spec.whatwg.org/multipage/parsing.html#markup-declaration-open-state
    func handleMarkupDeclarationOpenState() {
        // If the next few characters are:
        switch consumeNextInputCharacter() {
        // U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN (-->)
        case "-":
            if data.count > position + 1,
               data[position + 1] == UInt8(ascii: "-")
            {
                // Consume them.
                position += 1
                // Create a comment token whose data is the empty string. Switch to the comment start state.
                currentToken = .comment("")
                state = .commentStart
                return
            }

        // ASCII case-insensitive match for the word "DOCTYPE"
        case "D", "d":
            if data.count > position + 6,
               data[position + 1] == UInt8(ascii: "O")
               || data[position + 1] == UInt8(ascii: "o"),
               data[position + 2] == UInt8(ascii: "C")
               || data[position + 2] == UInt8(ascii: "c"),
               data[position + 3] == UInt8(ascii: "T")
               || data[position + 3] == UInt8(ascii: "t"),
               data[position + 4] == UInt8(ascii: "Y")
               || data[position + 4] == UInt8(ascii: "y"),
               data[position + 5] == UInt8(ascii: "P")
               || data[position + 5] == UInt8(ascii: "p"),
               data[position + 6] == UInt8(ascii: "E")
               || data[position + 6] == UInt8(ascii: "e")
            {
                // Consume those characters and switch to the DOCTYPE state.
                position += 6
                state = .doctype
                return
            }

        // The string "[CDATA[" (the five uppercase letters "CDATA" with a U+005B
        // LEFT SQUARE BRACKET character before and after)
        case "[":
            if data.count > position + 6,
               data[position + 1] == UInt8(ascii: "C"),
               data[position + 2] == UInt8(ascii: "D"),
               data[position + 3] == UInt8(ascii: "A"),
               data[position + 4] == UInt8(ascii: "T"),
               data[position + 5] == UInt8(ascii: "A"),
               data[position + 6] == UInt8(ascii: "[")
            {
                // Consume those characters. If there is an adjusted current node and it
                // is not an element in the HTML namespace, then switch to the CDATA
                // section state. Otherwise, this is a cdata-in-html-content parse
                // error. Create a comment token whose data is the "[CDATA[" string.
                // Switch to the bogus comment state.
                position += 6
                // FIXME: if let adjustedCurrentNode = adjustedCurrentNode, !adjustedCurrentNode.isHTMLElement() {
                //           state = .cdataSection
                currentToken = .comment("[CDATA[")
                state = .bogusComment
                return
            }

        default:
            break
        }

        // Anything else
        // This is an incorrectly-opened-comment parse error. Create a comment token
        // whose data is the empty string. Switch to the bogus comment state (don't
        // consume anything in the current state).
        currentToken = .comment("")
        state = .bogusComment
    }
}
