extension HTML.Tokenizer {
    // 13.2.5.9 RCDATA less-than sign state
    // https://html.spec.whatwg.org/multipage/parsing.html#rcdata-less-than-sign-state
    func handleRcDataLessThanSignState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+002F SOLIDUS (/)
        case "/":
            // Set the temporary buffer to the empty string
            temporaryBuffer = ""

            // Switch to the RCDATA end tag open state.
            state = .rcDataEndTagOpen

        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token.
            emitCharacterToken("<")

            // Reconsume in the RAWTEXT state.
            reconsume(.rcData)
        }
    }
}
