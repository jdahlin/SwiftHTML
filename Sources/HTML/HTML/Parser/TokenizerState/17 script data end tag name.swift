extension HTML.Tokenizer {
    // 13.2.5.17 Script data end tag name state
    // https://html.spec.whatwg.org/multipage/parsing.html#script-data-end-tag-name-state
    func handleScriptDataEndTagNameState() {
        // Consume the next input character:
        switch consumeNextInputCharacter() {
        // U+0009 CHARACTER TABULATION (tab)
        // U+000A LINE FEED (LF)
        // U+000C FORM FEED (FF)
        // U+0020 SPACE
        case "\u{0009}", "\u{000A}", "\u{000C}", "\u{0020}":

            // If the current end tag token is an appropriate end tag token,
            // then switch to the before attribute name state.
            if isCurrentEndTagTokenAppropriateEndTagToken() {
                state = .beforeAttributeName
                // Otherwise, treat it as per the "anything else" entry below.
            } else {
                anythingElse()
            }
        // U+002F SOLIDUS (/)
        case "/":
            // If the current end tag token is an appropriate end tag token
            // then switch to the self-closing start tag state.
            if isCurrentEndTagTokenAppropriateEndTagToken() {
                state = .selfClosingStartTag
                // Otherwise, treat it as per the "anything else" entry below.
            } else {
                anythingElse()
            }
        // U+003E GREATER-THAN SIGN (>)
        case ">":
            // If the current end tag token is an appropriate end tag token,
            // then switch to the data state and emit the current tag token.
            if isCurrentEndTagTokenAppropriateEndTagToken() {
                state = .data
                emitCurrentToken()
                // TODO: Otherwise, treat it as per the "anything else" entry below.
            } else {
                anythingElse()
            }

        // ASCII upper alpha
        case let c where c!.isASCIIUpperAlpha:
            // Append the lowercase version of the current input character
            // (add 0x0020 to the character's code point) to the current tag token's tag name.
            // Append the current input character to the temporary buffer.
            temporaryBuffer.append(currentInputCharacter()!.lowercased())

        // ASCII lower alpha
        case let c where c!.isASCIILowerAlpha:
            // Append the current input character to the current tag token's tag name.
            // Append the current input character to the temporary buffer.
            temporaryBuffer.append(currentInputCharacter()!)
        // Anything else
        default:
            anythingElse()
        }

        func anythingElse() {
            // Emit a U+003C LESS-THAN SIGN character token,
            emitCharacterToken("<")
            // a U+002F SOLIDUS character token,
            emitCharacterToken("/")
            // and a character token for each of the characters in the temporary
            // buffer (in the order they were added to the buffer).
            for c in temporaryBuffer {
                emitCharacterToken(c)
            }
            // Reconsume in the script data state.
            reconsume(.scriptData)
        }
    }
}
