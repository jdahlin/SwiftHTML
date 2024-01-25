extension HTML.Tokenizer {
    // 13.2.5.54 Before DOCTYPE name state
    // https://html.spec.whatwg.org/multipage/parsing.html#before-doctype-name-state
    func handleBeforeDoctypeNameState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        // Ignore the character.
        case "\u{0009}", "\u{000A}", "\u{000C}", " ":
            break

        // ASCII upper alpha
        case let character where character!.isASCIIUpperAlpha:
            // Create a new DOCTYPE token.
            createDocTypeToken()

            // Set the token's name to the lowercase version of the current
            // input character (add 0x0020 to the character's code point).
            currentDocTypeToken.name = character!.lowercased()

            // Switch to the DOCTYPE name state.
            state = .doctypeName

        // U+0000 NULL
        case "\u{0000}":
            // This is an unexpected-null-character parse error.
            // Create a new DOCTYPE token.
            createDocTypeToken()

            // Set the token's name to a U+FFFD REPLACEMENT CHARACTER character.
            currentDocTypeToken.name = "\u{FFFD}"

            // Switch to the DOCTYPE name state.
            state = .doctypeName

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // This is a missing-doctype-name parse error.
            // Create a new DOCTYPE token.
            createDocTypeToken()

            // Set its force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Switch to the data state.
            state = .data

            // Emit the current token.
            emitCurrentToken()

        // EOF
        case nil:
            // This is an eof-in-doctype parse error.
            // Create a new DOCTYPE token.
            createDocTypeToken()

            // Set its force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Emit the current token.
            emitCurrentToken()

            // Emit an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        case let character:
            // Create a new DOCTYPE token.
            createDocTypeToken()

            // Set the token's name to the current input character.
            currentDocTypeToken.name = String(character!)

            // Switch to the DOCTYPE name state.
            state = .doctypeName
        }
    }
}
