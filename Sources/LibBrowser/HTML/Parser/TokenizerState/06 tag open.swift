extension HTML.Tokenizer {
    // 13.2.5.6 Tag open state
    // https://html.spec.whatwg.org/multipage/parsing.html#tag-open-state
    func handleTagOpenState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0021 EXCLAMATION MARK (!)
        case "!":
            // Switch to the markup declaration open state.
            state = .markupDeclarationOpen

        // U+002F SOLIDUS (/)
        case "/":
            // Switch to the end tag open state.
            state = .endTagOpen

        // ASCII alpha
        case let char where char!.isLetter:
            // Create a new start tag token, set its tag name to the empty string.
            currentToken = .startTag(HTML.TokenizerTag(name: ""))
            // Reconsume in the tag name state.
            reconsume(.tagName)

        // U+003F QUESTION MARK (?)
        case "?":
            // This is an unexpected-question-mark-instead-of-tag-name parse error.
            // Create a comment token whose data is the empty string.
            currentCommentToken = .init(data: "")
            // Reconsume in the bogus comment state.
            reconsume(.bogusComment)

        // EOF
        case nil:
            // This is an eof-before-tag-name parse error.
            // Emit a U+003C LESS-THAN SIGN character token and
            emitCharacterToken("<")
            // an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        default:
            // This is an invalid-first-character-of-tag-name parse error.
            // Emit a U+003C LESS-THAN SIGN character token.
            emitCharacterToken("<")
            // Reconsume in the data state.
            reconsume(.data)
        }
    }
}
