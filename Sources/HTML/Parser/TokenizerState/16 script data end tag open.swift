extension Tokenizer {
    // 13.2.5.16 Script data end tag open state
    // https://html.spec.whatwg.org/multipage/parsing.html#script-data-end-tag-open-state
    func handleScriptDataEndTagOpenState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // ASCII alpha
        case let c where c!.isASCIIAlpha:
            // Create a new end tag token, set its tag name to the empty string.
            currentToken = .endTag("")

            // Reconsume in the script data end tag name state.
            reconsume(.scriptDataEndTagName)

        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token and
            emitCharacterToken("<")
            // a U+002F SOLIDUS character token.
            emitCharacterToken("/")
            // Reconsume in the script data state.
            reconsume(.scriptData)
        }
    }
}
