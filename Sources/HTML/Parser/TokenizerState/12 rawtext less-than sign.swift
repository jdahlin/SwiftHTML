extension Tokenizer {
    // 13.2.5.12 RAWTEXT less-than sign state
    // https://html.spec.whatwg.org/multipage/parsing.html#rawtext-less-than-sign-state
    func handleRawTextLessThanState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+002F SOLIDUS (/)
        case "/":
            // Set the temporary buffer to the empty string
            temporaryBuffer = ""

            // Switch to the RAWTEXT end tag open state.
            state = .rawTextEndTagOpen

        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token.
            emitCharacterToken("<")

            // Reconsume in the RAWTEXT state.
            reconsume(.rawText)
        }
    }
}
