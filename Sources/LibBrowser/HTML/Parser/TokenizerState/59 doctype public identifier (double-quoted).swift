extension HTML.Tokenizer {
    // 13.2.5.59 DOCTYPE public identifier (double-quoted) state
    // https://html.spec.whatwg.org/multipage/parsing.html#doctype-public-identifier-(double-quoted)-state
    func handleDoctypePublicIdentifierDoubleQuotedState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0022 QUOTATION MARK (")
        case "\"":
            // Switch to the after DOCTYPE public identifier state.
            state = .afterDoctypePublicIdentifier

        // U+0000 NULL
        case "\u{0000}":
            // This is an unexpected-null-character parse error.
            // Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's public identifier.
            currentDocTypeToken.publicIdentifier!.append("\u{FFFD}")

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // This is a missing-quotes-in-doctype-public-identifier parse error.
            // Set the DOCTYPE token's force-quirks flag to on.
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
            // Append the current input character to the current DOCTYPE token's public identifier.
            currentDocTypeToken.publicIdentifier!.append(consumeNextInputCharacter()!)
        }
    }
}
