extension Tokenizer {
    // 13.2.5.15 Script data less-than sign state
    // https://html.spec.whatwg.org/multipage/parsing.html#script-data-less-than-sign-state
    func handleScriptDataLessThanSignState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+002F SOLIDUS (/)
        case "/":
            // Set the temporary buffer to the empty string. Switch to the
            // script data end tag open state.
            temporaryBuffer = ""
            state = .scriptDataEndTagOpen
        // U+0021 EXCLAMATION MARK (!)
        case "!":
            // Switch to the script data escape start state. Emit a U+003C
            // LESS-THAN SIGN character token and a U+0021 EXCLAMATION MARK
            // character token.
            state = .scriptDataEscapeStart
            emitCharacterToken("<")
            emitCharacterToken("!")
        // Anything else
        default:
            // Emit a U+003C LESS-THAN SIGN character token.
            emitCharacterToken("<")
            // Reconsume in the script data state.
            reconsume(.scriptData)
        }
    }
}
