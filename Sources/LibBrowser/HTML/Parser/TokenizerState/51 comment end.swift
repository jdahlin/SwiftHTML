extension HTML.Tokenizer {
    // 13.2.5.51 Comment end state
    // https://html.spec.whatwg.org/multipage/parsing.html#comment-end-state
    func handleCommentEndState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+003E GREATER-THAN SIGN (>)
        // Switch to the data state. Emit the current comment token.
        case ">":
            state = .data
            emitCurrentToken()

        // U+0021 EXCLAMATION MARK (!)
        // Switch to the comment end bang state.
        case "!":
            state = .commentEndBang

        // U+002D HYPHEN-MINUS (-)
        // Append a U+002D HYPHEN-MINUS character (-) to the comment token's data.
        case "-":
            appendCurrenTagTokenName("-")

        // EOF
        // This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
        case nil:
            emitCurrentToken()
            emitEndOfFileToken()

        // Anything else
        // Append two U+002D HYPHEN-MINUS characters (-) to the comment token's data. Reconsume in the comment state.
        default:
            appendCurrenTagTokenName("-")
            appendCurrenTagTokenName("-")
            reconsume(.comment)
        }
    }
}
