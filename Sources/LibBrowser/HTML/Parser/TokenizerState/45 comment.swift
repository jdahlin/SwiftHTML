extension HTML.Tokenizer {
    // 13.2.5.45 Comment state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-state
    func handleCommentState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003C LESS-THAN SIGN (<)
        case "<":
            // Append the current input character to the comment token's data. Switch to the comment less-than sign state.
            appendCurrenTagTokenName(currentInputCharacter()!)
            state = .commentLessThanSign

        // U+002D HYPHEN-MINUS (-)
        case "-":
            // Switch to the comment end dash state.
            state = .commentEndDash

        // U+0000 NULL
        case "\0":
            // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the comment token's data.
            appendCurrenTagTokenName("\u{FFFD}")

        // EOF
        case nil:
            // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
            emitCurrentToken()
            emitEndOfFileToken()

        // Anything else
        // Append the current input character to the comment token's data.
        default:
            appendCurrenTagTokenName(currentInputCharacter()!)
        }
    }
}
