extension Tokenizer {
    // 13.2.5.13 RAWTEXT end tag open state
    // https://html.spec.whatwg.org/multipage/parsing.html#rawtext-end-tag-open-state
    func handleRawTextEndTagOpenState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // ASCII alpha
        case let c where c!.isASCIIAlpha:
            // Create a new end tag token, set its tag name to the empty string.
            currentToken = .endTag("")
            // Reconsume in the RAWTEXT end tag name state.
            reconsume(.rawTextEndTagName)

        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token and
            emitCharacterToken("<")
            // a U+002F SOLIDUS character token.
            emitCharacterToken("/")
            // Reconsume in the RAWTEXT state.
            reconsume(.rawText)
        }
    }
}
