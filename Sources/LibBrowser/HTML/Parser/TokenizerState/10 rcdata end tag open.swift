extension HTML.Tokenizer {
    // 13.2.5.10 RCDATA end tag open state
    // https://html.spec.whatwg.org/multipage/parsing.html#rcdata-end-tag-open-state
    func handleRcDataEndTagOpenState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // ASCII alpha
        case let c where c!.isASCIIAlpha:
            // Create a new end tag token, set its tag name to the empty string.
            currentToken = .endTag(HTML.TokenizerTag(name: ""))

            // Reconsume in the RCDATA end tag name state.
            reconsume(.rcDataEndTagName)

        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token.
            emitCharacterToken("<")

            // and a U+002F SOLIDUS character token
            emitCharacterToken("/")

            // Reconsume in the RCDATA state.
            reconsume(.rcData)
        }
    }
}
