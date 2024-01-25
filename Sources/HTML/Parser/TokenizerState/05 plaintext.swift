extension Tokenizer {
    // 13.2.5.5 PLAINTEXT state
    // https://html.spec.whatwg.org/multipage/parsing.html#plaintext-state
    func handlePlaintextState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
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
