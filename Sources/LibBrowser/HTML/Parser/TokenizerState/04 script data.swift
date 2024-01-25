extension HTML.Tokenizer {
    // 13.2.5.4 Script data state
    // https://html.spec.whatwg.org/multipage/parsing.html#script-data-state
    func handleScriptDataState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003C LESS-THAN SIGN (<)
        case "<":
            // Switch to the script data less-than sign state.
            state = .scriptDataLessThanSign
        // U+0000 NULL
        case "\u{0000}":
            // Parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
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
