extension TreeBuilder {
    // 13.2.6.4.4 The "in head" insertion mode
    // https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inhead
    func handleInHead(_ token: Token) {
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
            insertACharachter([c])

        // A comment token
        case let .comment(comment):
            // Insert a comment.
            insertAComment(comment)

        // A DOCTYPE token
        case .doctype:
            // Parse error. Ignore the token.
            break

        // A start tag whose tag name is "html"
        case .startTag("html", attributes: _, _):
            // Process the token using the rules for the "in body" insertion mode.
            insertionMode = .inBody
            handleInBody(token)

        // A start tag whose tag name is one of: "base", "basefont", "bgsound", "link"
        case let .startTag(tagName, _, _)
            where tagName == "base" || tagName == "basefont" || tagName == "bgsound" || tagName == "link":
            // Insert an HTML element for the token.
            insertHTMLElement(token)

            // Immediately pop the current node off the stack of open elements.

            // FIXME: Acknowledge the token's self-closing flag, if it is set.

        // A start tag whose tag name is "meta"
        case .startTag("meta", _, _):
            // Insert an HTML element for the token.
            let element = insertHTMLElement(token)
            // Immediately pop the current node off the stack of open elements.
            // FIXME: Acknowledge the token's self-closing flag, if it is set.

            // If the active speculative HTML parser is null, then:
            if activeSpeculativeHTMLParser != nil {
                FIXME("activeSpeculativeHTMLParser not implemented")
            }

            // If the element has a charset attribute, and getting an encoding from
            // its value results in an encoding, and the confidence is currently
            // tentative, then change the encoding to the resulting encoding.
            if element.hasAttribute("charset") {
                FIXME("charset not implemented")
                // Otherwise, if the element has an http-equiv attribute whose value is an
                // ASCII case-insensitive match for the string "Content-Type", and the
                // element has a content attribute, and applying the algorithm for
                // extracting a character encoding from a meta element to that attribute's
                // value returns an encoding, and the confidence is currently tentative,
                // then change the encoding to the extracted encoding. The speculative
                // HTML parser doesn't speculatively apply character encoding declarations
                // in order to reduce implementation complexity.
            } else if element.hasAttribute("http-equiv"),
                      element.getAttribute("http-equiv") == "Content-Type", element.hasAttribute("content")
            {
                FIXME("http-equiv not implemented")
            }

        // A start tag whose tag name is "title"
        case .startTag("title", attributes: _, _):
            // Follow the generic RCDATA element parsing algorithm.
            FIXME("title not implemented")

        // A start tag whose tag name is "noscript", if the scripting flag is enabled
        case .startTag("noscript", attributes: _, _) where scriptingFlag:
            // Follow the generic raw text element parsing algorithm.
            FIXME("noscript not implemented")

        // A start tag whose tag name is one of: "noframes", "style"
        case .startTag(let tagName, attributes: _, _) where tagName == "noframes" || tagName == "style":
            // Follow the generic raw text element parsing algorithm.
            FIXME("\(tagName) not implemented")

        // A start tag whose tag name is "noscript", if the scripting flag is disabled
        case .startTag("noscript", attributes: _, _) where !scriptingFlag:
            // Insert an HTML element for the token.
            _ = insertHTMLElement(token)

            // Switch the insertion mode to "in head noscript".
            insertionMode = .inHeadNoscript

            FIXME("noscript not implemented")

        // A start tag whose tag name is "script"
        case .startTag("script", _, _):
            // Run these steps:
            // Let the adjusted insertion location be the appropriate place for inserting a node.
            let adjustedInsertionLocation = appropriatePlaceForInsertingANode()

            // Create an element for the token in the HTML namespace, with the
            // intended parent being the element in which the adjusted insertion
            // location finds it
            let element = document.createElement("script")

            // Set the element's parser document to the Document, and set the element's force async to false.
            // element.forceAsync = false
            // if isFragmentParsing {
            //     element.alreadyStarted = true
            // }

            // Insert the newly created element at the adjusted insertion location.
            adjustedInsertionLocation.insert(element)
            // Push the element onto the stack of open elements so that it is the new current node.
            stack.append(element)
            // Switch the tokenizer to the script data state.
            tokenizer.state = .scriptData
            // Let the original insertion mode be the current insertion mode.
            originalInsertionMode = insertionMode
            // Switch the insertion mode to "text".
            insertionMode = .text

        // An end tag whose tag name is "head"
        case .endTag("head", _, _):
            // Pop the current node (which will be the head element) off the stack of open elements.
            stack.removeLast()

            // Switch the insertion mode to "after head".
            insertionMode = .afterHead

        // An end tag whose tag name is one of: "body", "html", "br"
        case let .endTag(tagName, _, _) where tagName == "body" || tagName == "html" || tagName == "br":
            // Act as described in the "anything else" entry below. (inlined)
            // Pop the current node (which will be the head element) off the stack of open elements.
            stack.removeLast()

            // Switch the insertion mode to "after head".
            insertionMode = .afterHead

            // Reprocess the token.
            reprocessToken(token)

    // A start tag whose tag name is "template"
    // Let template start tag be the start tag.
    // Insert a marker at the end of the list of active formatting elements.
    // Set the frameset-ok flag to "not ok".
    // Switch the insertion mode to "in template".
    // Push "in template" onto the stack of template insertion modes so that it is the new current template insertion mode.
    // Let the adjusted insertion location be the appropriate place for inserting a node.
    // Let intended parent be the element in which the adjusted insertion location finds it
    // Let document be intended parent's node document.
    // If any of the following are false:
    // template start tag's shadowrootmode is not in the none state;
    // Document's allow declarative shadow roots is true; or
    // the adjusted current node is not the topmost element in the stack of open elements,
    // then insert an HTML element for the token.
    // Otherwise:
    // Let declarative shadow host element be adjusted current node.
    // Let template be the result of insert a foreign element for template start tag, with HTML namespace and true.
    // Let declarative shadow mode be template start tag's shadowrootmode attribute.
    // If template start tag had a shadowrootdelegatesfocus attribute, then let declarative shadow delegates focus be true. Otherwise let it be false.
    // Attach a shadow root with declarative shadow host element, declarative shadow mode, true, declarative shadow delegates focus, and "named".
    // If an exception was thrown by attach a shadow root, then catch it, and run these steps:
    // Report the exception.
    // Insert an element at the adjusted insertion location with template.
    // Otherwise:
    // Let shadow be declarative shadow host element's shadow root.
    // Set shadow's declarative to true.
    // Set template's template contents property to shadow.
    // Set shadow's available to element internals to true.

    // An end tag whose tag name is "template"
    // If there is no template element on the stack of open elements, then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate all implied end tags thoroughly.
    // If the current node is not a template element, then this is a parse error.
    // Pop elements from the stack of open elements until a template element has been popped from the stack.
    // Clear the list of active formatting elements up to the last marker.
    // Pop the current template insertion mode off the stack of template insertion modes.
    // Reset the insertion mode appropriately.

        // A start tag whose tag name is "head"
        case .startTag("head", attributes: _, _):
            // Parse error. Ignore the token.
            break

        // Any other end tag
        case .endTag:
            // Parse error. Ignore the token.
            break

        // Anything else
        default:
            // Pop the current node (which will be the head element) off the stack of open elements.
            stack.removeLast()

            // Switch the insertion mode to "after head".
            insertionMode = .afterHead

            // Reprocess the token.
            reprocessToken(token)
        }
    }
}
