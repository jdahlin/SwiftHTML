extension HTML.Tokenizer {
    // 13.2.5.58 Before DOCTYPE public identifier state
    // https://html.spec.whatwg.org/multipage/parsing.html#before-doctype-public-identifier-state
    func handleBeforeDoctypePublicIdentifierState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        case "\u{0009}", "\u{000A}", "\u{000C}", " ":
            // Ignore the character.
            break

        // U+0022 QUOTATION MARK (")
        case "\"":
            // Set the current DOCTYPE token's public identifier to the empty string
            // (not missing)
            currentDocTypeToken.publicIdentifier = ""

            // then switch to the DOCTYPE public identifier (double-quoted) state.
            state = .doctypePublicIdentifierDoubleQuoted

        // U+0027 APOSTROPHE (')
        case "'":
            // Set the current DOCTYPE token's public identifier to the empty string
            // (not missing)
            currentDocTypeToken.publicIdentifier = ""

            // then switch to the DOCTYPE public identifier (single-quoted) state.
            state = .doctypePublicIdentifierSingleQuoted

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // This is a missing-doctype-public-identifier parse error.
            // Set the current DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

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

        // Anything else
        default:
            // This is a missing-quote-before-doctype-public-identifier parse error.
            // Set the current DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Reconsume in the bogus DOCTYPE state.
            reconsume(.bogusDoctype)
        }
    }
}
