extension HTML.TreeBuilder {
    // 13.2.6.4.19 The "after body" insertion mode
    // https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-afterbody
    func handleAfterBody(_ token: HTML.Token) {
        switch token {
        // A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE
        // FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020
        // SPACE
        case let .character(c)
            where c == "\u{0009}" || c == "\u{000A}" || c == "\u{000C}" || c == "\u{000D}"
            || c == "\u{0020}":
            // Process the token using the rules for the "in body" insertion mode.
            handleInBody(token)

        // A comment token
        case let .comment(comment):
            // Insert a comment as the last child of the first element in the stack of open elements (the html element).
            insertAComment(comment)

        // A DOCTYPE token
        case .doctype:
            // Parse error. Ignore the token.
            break

        // A start tag whose tag name is "html"
        case let .startTag(tag) where tag.name == "html":
            // Process the token using the rules for the "in body" insertion mode.
            handleInBody(token)

        // An end tag whose tag name is "html"
        case let .endTag(tag) where tag.name == "html":
            if isFragmentParsing {
                // Parse error. Ignore the token.
            } else {
                // Switch the insertion mode to "after after body".
                insertionMode = .afterAfterBody
            }

        // An end-of-file token
        case .eof:
            // Stop parsing.
            break

        default:
            // Parse error.

            // Switch the insertion mode to "in body"
            insertionMode = .inBody

            // reprocess the token.
            reprocessToken(token)
        }
    }
}
