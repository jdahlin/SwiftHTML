extension HTML.Tokenizer {
    // 13.2.5.57 After DOCTYPE public keyword state
    // https://html.spec.whatwg.org/multipage/parsing.html#after-doctype-public-keyword-state

    func handleAfterDoctypePublicKeywordState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        case "\u{0009}", "\u{000A}", "\u{000C}", " ":
            // Switch to the before DOCTYPE public identifier state.
            state = .beforeDoctypePublicIdentifier

        // U+0022 QUOTATION MARK (")
        case "\"":
            // This is a missing-whitespace-after-doctype-public-keyword parse error.
            // Set the current DOCTYPE token's public identifier to the empty string (not missing)
            currentDocTypeToken.publicIdentifier = ""

            // then switch to the DOCTYPE public identifier (double-quoted) state.
            state = .doctypePublicIdentifierDoubleQuoted

        // U+0027 APOSTROPHE (')
        case "'":
            // This is a missing-whitespace-after-doctype-name parse error.
            // Set the DOCTYPE token's public identifier to the empty string (not missing),
            currentDocTypeToken.publicIdentifier = ""

            // then switch to the DOCTYPE public identifier (single-quoted) state.
            state = .doctypePublicIdentifierSingleQuoted

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // This is a missing-whitespace-after-doctype-name parse error.
            // Set the DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Switch to the data state.
            state = .data

            // Emit the current DOCTYPE token.
            emitCurrentDocTypeToken()

        // EOF
        case nil:
            // This is an eof-in-doctype parse error.
            // Set the DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true

            // Emit the current DOCTYPE token.
            emitCurrentDocTypeToken()

            // Emit an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        default:
            // This is a missing-whitespace-after-doctype-name parse error.
            // Set the DOCTYPE token's force-quirks flag to on.
            currentDocTypeToken.forceQuirks = true
            // Reconsume in the bogus DOCTYPE state.
            reconsume(.bogusDoctype)
        }
    }
}
