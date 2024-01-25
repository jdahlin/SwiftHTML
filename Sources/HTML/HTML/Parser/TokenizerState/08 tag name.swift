extension HTML.Tokenizer {
    // 13.2.5.8 Tag name state
    // https://html.spec.whatwg.org/multipage/parsing.html#tag-name-state
    func handleTagNameState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        case "\t", "\n", "\r", " ":
            // Switch to the before attribute name state.
            state = .beforeAttributeName

        // U+002F SOLIDUS (/)
        case "/":
            // Switch to the self-closing start tag state.
            state = .selfClosingStartTag

        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // Switch to the data state. Emit the current tag token.
            state = .data
            emitCurrentToken()

        // ASCII upper alpha
        // Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name.
        case let char where char!.isUppercase:
            let cic = currentInputCharacter()!
            appendCurrenTagTokenName(
                Character(UnicodeScalar(cic.unicodeScalars.first!.value + 0x0020)!))

        // U+0000 NULL
        // This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current tag token's tag name.
        case "\0":
            appendCurrenTagTokenName("\u{FFFD}")

        // EOF
        // This is an eof-in-tag parse error. Emit an end-of-file token.
        case nil:
            emitEndOfFileToken()

        // Anything else
        // Append the current input character to the current tag token's tag name.
        default:
            appendCurrenTagTokenName(currentInputCharacter()!)
        }
    }
}
