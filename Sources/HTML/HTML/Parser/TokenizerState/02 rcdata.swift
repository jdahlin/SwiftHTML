extension HTML.Tokenizer {
    // 13.2.5.2 RCDATA state
    // https://html.spec.whatwg.org/multipage/parsing.html#rcdata-state
    func handleRcDataState() {
        switch consumeNextInputCharacter() {
        // U+0026 AMPERSAND (&)
        case "&":
            // Set the return state to the RCDATA state. Switch to the character
            // reference state.
            returnState = .rcData
            state = .characterReference

        // U+003C LESS-THAN SIGN (<)
        case "<":
            // Switch to the RCDATA less-than sign state.
            state = .rcDataLessThanSign

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
