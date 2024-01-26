extension HTML.Tokenizer {
    // 13.2.5.45 Comment state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-state
    func handleCommentState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003C LESS-THAN SIGN (<)
        case "<":
            // Append the current input character to the comment token's data.
            currentCommentToken.data.append(currentInputCharacter()!)

            // Switch to the comment less-than sign state.
            state = .commentLessThanSign

        // U+002D HYPHEN-MINUS (-)
        case "-":
            // Switch to the comment end dash state.
            state = .commentEndDash

        // U+0000 NULL
        case "\0":
            // This is an unexpected-null-character parse error.
            // Append a U+FFFD REPLACEMENT CHARACTER character to the comment token's data.
            currentCommentToken.data.append("\u{FFFD}")

        // EOF
        case nil:
            // This is an eof-in-comment parse error.
            // Emit the current comment token.
            emitToken(.comment(currentCommentToken))
            // Emit an end-of-file token.
            emitEndOfFileToken()

        // Anything else
        default:
            // Append the current input character to the comment token's data.
            currentCommentToken.data.append(currentInputCharacter()!)
        }
    }
}
