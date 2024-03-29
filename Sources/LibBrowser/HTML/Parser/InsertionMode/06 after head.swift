extension HTML.TreeBuilder {
    // 13.2.6.4.6 The "after head" insertion mode
    func handleAfterHead(_ token: HTML.Token) {
        switch token {
        // A character token that is one of
        // - U+0009 CHARACTER TABULATION,
        // - U+000A LINE FEED (LF),
        // - U+000C FORM FEED (FF),
        // - U+000D CARRIAGE RETURN (CR), or
        // - U+0020 SPACE
        case let .character(c)
            where c == "\u{0009}" || c == "\u{000A}" || c == "\u{000C}" || c == "\u{000D}"
            || c == "\u{0020}":
            // Insert the character.
            insertACharacter([c])

        // A comment token
        case let .comment(comment):
            // Insert a comment.
            insertAComment(comment)

        // A DOCTYPE token
        case .doctype:
            // Parse error. Ignore the token.
            break

        // A start tag whose tag name is "html"
        case let .startTag(tag) where tag.name == "html":
            // Process the token using the rules for the "in body" insertion mode.
            handleInBody(token)

        // A start tag whose tag name is "body"
        case let .startTag(tag) where tag.name == "body":
            // Insert an HTML element for the token.
            insertHTMLElement(token)
            // Set the frameset-ok flag to "not ok".
            framesetOkFlag = .notOk
            // Switch the insertion mode to "in body".
            insertionMode = .inBody

        // A start tag whose tag name is "frameset"
        case let .startTag(tag) where tag.name == "frameset":
            // Insert an HTML element for the token.
            insertHTMLElement(token)
            // Switch the insertion mode to "in frameset".
            insertionMode = .inFrameset

        // A start tag whose tag name is one of: "base", "basefont", "bgsound", "link", "meta", "noframes", "script", "style", "template", "title"
        case let .startTag(tag)
            where tag.name == "base" || tag.name == "basefont" || tag.name == "bgsound"
            || tag.name == "link" || tag.name == "meta" || tag.name == "noframes"
            || tag.name == "script" || tag.name == "style" || tag.name == "template"
            || tag.name == "title":
            // Parse error.
            // parseError("Unexpected start tag '\(tagName)' in 'in head' insertion mode.")

            // Push the node pointed to by the head element pointer onto the stack of open elements.
            stackOfOpenElements.push(element: headElementPointer!)

            // Process the token using the rules for the "in head" insertion mode.
            handleInHead(token)

            // Remove the node pointed to by the head element pointer from the
            // stack of open elements. (It might not be the current node at this
            // point.)
            stackOfOpenElements.removePointedBy(element: headElementPointer!)

            // The head element pointer cannot be null at this point.
            assert(headElementPointer != nil)

        // An end tag whose tag name is "template"
        case let .startTag(tag) where tag.name == "template":
            // Process the token using the rules for the "in head" insertion mode.
            handleInHead(token)

        // An end tag whose tag name is one of: "body", "html", "br"
        case let .endTag(tag) where tag.name == "body" || tag.name == "html" || tag.name == "br":
            // Act as described in the "anything else" entry below.

            // Insert an HTML element for a "body" start tag token with no attributes.
            insertHTMLElement(HTML.Token.startTag(HTML.TokenizerTag(name: "body")))

            // Switch the insertion mode to "in body".
            insertionMode = .inBody

            // Reprocess the current token.
            reprocessToken(token)

        // A start tag whose tag name is "head"
        case let .startTag(tag) where tag.name == "head":
            // Parse error. Ignore the token.
            break

        // Any other end tag
        case .endTag:
            // Parse error. Ignore the token.
            break

        // Anything else
        default:
            // Insert an HTML element for a "body" start tag token with no attributes.
            insertHTMLElement(HTML.Token.startTag(HTML.TokenizerTag(name: "body")))

            // Switch the insertion mode to "in body".
            insertionMode = .inBody

            // Reprocess the current token.
            reprocessToken(token)
        }
    }
}
