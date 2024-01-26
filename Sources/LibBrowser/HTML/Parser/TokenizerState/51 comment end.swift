extension HTML.Tokenizer {
    // 13.2.5.51 Comment end state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-end-state
    func handleCommentEndState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // Switch to the data state.
            state = .data
            //  Emit the current comment token.
            emitToken(.comment(currentCommentToken))

        // U+0021 EXCLAMATION MARK (!)
        case "!":
            // Switch to the comment end bang state.
            state = .commentEndBang

        // U+002D HYPHEN-MINUS (-)
        case "-":
            // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data.
            currentCommentToken.data.append("-")

        // EOF

        case nil:
            // This is an eof-in-comment parse error.
            // Emit the current comment token.
            emitToken(.comment(currentCommentToken))
            // Emit an end-of-file token.
            emitEndOfFileToken()

        // Anything else

        default:
            // Append two U+002D HYPHEN-MINUS characters (-) to the comment token's data.
            currentCommentToken.data.append("--")

            //  Reconsume in the comment state.
            reconsume(.comment)
        }
    }
}
