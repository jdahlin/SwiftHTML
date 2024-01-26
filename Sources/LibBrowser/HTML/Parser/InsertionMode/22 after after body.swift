extension HTML.TreeBuilder {
    // 13.2.6.4.22 The "after after body" insertion mode
    func handleAfterAfterBody(_ token: HTML.Token) {
        switch token {
        // A comment token
        case let .comment(comment):
            // Insert a comment as the last child of the Document object.
            insertAComment(comment)

        // A DOCTYPE token
        // A character token that is one of
        // U+0009 CHARACTER TABULATION,
        // U+000A LINE FEED (LF),
        // U+000C FORM FEED (FF),
        // U+000D CARRIAGE RETURN (CR), or
        // U+0020 SPACE
        case
            .doctype,
            .character("\u{0009}"), .character("\u{000A}"), .character("\u{000C}"),
            .character("\u{000D}"), .character("\u{0020}"):
            // Process the token using the rules for the "in body" insertion mode.
            handleInBody(token)

        // A start tag whose tag name is "html"
        case let .startTag(tag) where tag.name == "html":
            // Process the token using the rules for the "in body" insertion mode.
            handleInBody(token)

        // An end-of-file token
        case .eof:
            // Stop parsing.
            stopParsing()

        // Anything else
        default:
            // Parse error.
            // Switch the insertion mode to "in body" and
            insertionMode = .inBody

            // reprocess the token.
            reprocessToken(token)
        }
    }
}
