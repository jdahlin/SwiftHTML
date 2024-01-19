extension Tokenizer {
    // 13.2.5.43 Comment start state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-start-state
    func handleCommentStartState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+002D HYPHEN-MINUS (-)
        case "-":
            // Switch to the comment start dash state.
            state = .commentStartDash

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // This is an abrupt-closing-of-empty-comment parse error. Switch to the data state. Emit the current comment token.
            state = .data
            emitCurrentToken()

        // Anything else
        default:
            // Reconsume in the comment state.
            reconsume(.comment)
        }
    }
}
