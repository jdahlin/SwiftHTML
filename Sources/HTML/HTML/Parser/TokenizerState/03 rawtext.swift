extension HTML.Tokenizer {
    // 13.2.5.3 RAWTEXT state
    // https://html.spec.whatwg.org/multipage/parsing.html#rawtext-state
    func handleRawTextState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003C LESS-THAN SIGN (<)
        case "<":
            // Switch to the RAWTEXT less-than sign state.
            state = .rawTextLessThanSign

        // U+0000 NULL
        case "\0":
            // This is an unexpected-null-character parse error. Emit a U+FFFD
            // REPLACEMENT CHARACTER character token.
            emitCharacterToken("\u{FFFD}")

        // EOF
        case nil:
            // Emit an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        default:
            // Emit the current input character as a character token.
            emitCharacterToken(currentInputCharacter()!)
        }
    }
}
