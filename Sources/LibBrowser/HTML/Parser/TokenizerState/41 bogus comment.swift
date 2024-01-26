extension HTML.Tokenizer {
    // 13.2.5.41 Bogus comment state
    // https://html.spec.whatwg.org/multipage/parsing.html#bogus-comment-state
    func handleBogusCommentState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // Switch to the data state.
            state = .data

            // Emit the current comment token.
            emitToken(.comment(currentCommentToken))

        // EOF
        case nil:
            // Emit the comment.
            emitToken(.comment(currentCommentToken))

            //  Emit an end-of-file token.
            emitEndOfFileToken()

        // U+0000 NULL
        case "\0":
            // This is an unexpected-null-character parse error.

            // Append a U+FFFD REPLACEMENT CHARACTER character to the comment
            // token's data.
            currentCommentToken.data.append("\u{FFFD}")

        // Anything else
        default:
            // Append the current input character to the comment token's data.
            currentCommentToken.data.append(currentInputCharacter()!)
        }
    }
}
