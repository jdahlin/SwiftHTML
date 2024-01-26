extension HTML.Tokenizer {
    // 13.2.5.7 End tag open state
    // https://html.spec.whatwg.org/multipage/parsing.html#end-tag-open-state
    func handleEndTagOpenState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // ASCII alpha
        case let char where char!.isLetter:
            // Create a new end tag token,
            // set its tag name to the empty string.
            currentToken = .endTag(HTML.TokenizerTag(name: ""))
            // Reconsume in the tag name state.
            reconsume(.tagName)

        // U+003E GREATER-THAN SIGN (>)
        // This is a missing-end-tag-name parse error. Switch to the data state.
        case ">":
            state = .data

        // EOF
        case nil:
            // This is an eof-before-tag-name parse error.
            // Emit a U+003C LESS-THAN SIGN character token,
            emitCharacterToken("<")
            // a U+002F SOLIDUS character token and
            emitCharacterToken("/")
            // an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        default:
            // This is an invalid-first-character-of-tag-name parse error.
            // Create a comment token whose data is the empty string.
            currentCommentToken = .init(data: "")
            // Reconsume in the bogus comment state.
            reconsume(.bogusComment)
        }
    }
}
