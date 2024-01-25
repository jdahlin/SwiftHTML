extension HTML.Tokenizer {
    // 13.2.5.50 Comment end dash state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-end-dash-state
    func handleCommentEndDashState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+002D HYPHEN-MINUS (-)
        case "-":
            // Switch to the comment end state.
            state = .commentEnd

        // EOF
        case nil:
            // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
            emitCurrentToken()
            emitEndOfFileToken()

        // Anything else
        default:
            // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data. Reconsume in the comment state.
            appendCurrenTagTokenName("-")
            reconsume(.comment)
        }
    }
}
