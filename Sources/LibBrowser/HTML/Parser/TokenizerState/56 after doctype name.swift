extension HTML.Tokenizer {
    // 13.2.5.56 After DOCTYPE name state
    // https://html.spec.whatwg.org/multipage/parsing.html#after-doctype-name-state
    func handleAfterDoctypeNameState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        case "\u{0009}", "\u{000A}", "\u{000C}", " ":
            // Ignore the character.
            break

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // Switch to the data state.
            state = .data

            // Emit the current DOCTYPE token.
            emitCurrentDocTypeToken()

        // EOF
        case nil:
            // This is an eof-in-doctype parse error.

            // Set the current DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Emit the current DOCTYPE token.
            emitCurrentDocTypeToken()

            // Emit an end-of-file token.
            emitEndOfFileToken()

        // If the six characters starting from the current input character are an
        // ASCII case-insensitive match for the word "PUBLIC"
        case "P", "p":
            if data.count > position + 5,
               data[position + 1] == UInt8(ascii: "U")
               || data[position + 1] == UInt8(ascii: "u"),
               data[position + 2] == UInt8(ascii: "B")
               || data[position + 2] == UInt8(ascii: "b"),
               data[position + 3] == UInt8(ascii: "L")
               || data[position + 3] == UInt8(ascii: "l"),
               data[position + 4] == UInt8(ascii: "I")
               || data[position + 4] == UInt8(ascii: "i"),
               data[position + 5] == UInt8(ascii: "C")
               || data[position + 5] == UInt8(ascii: "c")
            {
                // then consume those characters and switch to the after DOCTYPE public keyword
                // state.
                state = .afterDoctypePublicKeyword
                position += 5
                return
            }

        // Otherwise, if the six characters starting from the current input
        // character are an ASCII case-insensitive match for the word "SYSTEM",
        case "S", "s":
            if data.count > position + 5,
               data[position + 1] == UInt8(ascii: "Y")
               || data[position + 1] == UInt8(ascii: "y"),
               data[position + 2] == UInt8(ascii: "S")
               || data[position + 2] == UInt8(ascii: "s"),
               data[position + 3] == UInt8(ascii: "T")
               || data[position + 3] == UInt8(ascii: "t"),
               data[position + 4] == UInt8(ascii: "E")
               || data[position + 4] == UInt8(ascii: "e"),
               data[position + 5] == UInt8(ascii: "M")
               || data[position + 5] == UInt8(ascii: "m")
            {
                // then consume those characters and switch to the after DOCTYPE system keyword
                // state.
                state = .afterDoctypeSystemKeyword
                position += 5
                return
            }

        // Otherwise
        default:
            // this is an invalid-character-sequence-after-doctype-name parse error.
            // Set the current DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Reconsume in the bogus DOCTYPE state.
            reconsume(.bogusDoctype)
        }
    }
}
