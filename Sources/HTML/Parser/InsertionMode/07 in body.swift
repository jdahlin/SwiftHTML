extension TreeBuilder {
    // 13.2.6.4.7 The "in body" insertion mode
    func handleInBody(_ token: Token) {
        switch token {
        // A character token that is U+0000 NULL
        case let .character(c) where c == "\u{0000}":
            // Parse error. Ignore the token.
            break

        // A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE
        // FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020
        // SPACE
        case let .character(c)
            where c == "\u{0009}" || c == "\u{000A}" || c == "\u{000C}" || c == "\u{000D}"
            || c == "\u{0020}":
            // Reconstruct the active formatting elements, if any.
            // Insert the token's character.
            insertACharacter([c])

        // Any other character token
        case let .character(c):
            // Reconstruct the active formatting elements, if any.
            // Insert the token's character.
            insertACharacter([c])

            // Set the frameset-ok flag to "not ok".
            framesetOkFlag = .notOk

        // A comment token
        case let .comment(comment):
            // Insert a comment.
            insertAComment(comment)

        // A DOCTYPE token
        case .doctype:
            // Parse error. Ignore the token.
            break

        // A start tag whose tag name is "html"
        case .startTag("html", _, _):
            // Parse error.
            // If there is a template element on the stack of open elements, then
            // ignore the token. Otherwise, for each attribute on the token, check to
            // see if the attribute is already present on the top element of the stack
            // of open elements. If it is not, add the attribute and its corresponding
            // value to that element.
            break

        // A start tag whose tag name is one of: "base", "basefont", "bgsound",
        // "link", "meta", "noframes", "script", "style", "template", "title"
        case let .startTag(tagName, _, _)
            where tagName == "base" || tagName == "basefont" || tagName == "bgsound" || tagName == "link"
            || tagName == "meta" || tagName == "noframes" || tagName == "script" || tagName == "style"
            || tagName == "template" || tagName == "title":
            // Process the token using the rules for the "in head" insertion mode.
            handleInHead(token)

        // An end tag whose tag name is "template"
        case .endTag("template", _, _):
            // Process the token using the rules for the "in head" insertion mode.
            handleInHead(token)

        // A start tag whose tag name is "body"
        case let .startTag("body", attributes, _):
            // Parse error.
            // If the second element on the stack of open elements is not a body
            // element, if the stack of open elements has only one node on it, or if
            // there is a template element on the stack of open elements, then ignore
            // the token. (fragment case or there is a template element on the stack)
            let openElements = stack
            if openElements.count > 1, openElements[1].tagName != "body",
               !openElements.contains(where: { $0.tagName == "template" })
            {
                /* do nothing */
            } else {
                // Otherwise, set the frameset-ok flag to "not ok"; then
                framesetOkFlag = .notOk

                // for each attribute on the token, check to see if the attribute is
                // already present on the body element (the second element) on the stack
                // of open elements, and if it is not, add the attribute and its
                // corresponding value to that element.
                for attribute in attributes {
                    if openElements.count > 1 {
                        let body = openElements[1]
                        if body.hasAttribute(attribute.name) {
                            body.setAttribute(attribute.name, attribute.value)
                        }
                    }
                }
            }

    // A start tag whose tag name is "frameset"
    // Parse error.
    // If the stack of open elements has only one node on it, or if the second element on the stack of open elements is not a body element, then ignore the token. (fragment case or there is a template element on the stack)
    // If the frameset-ok flag is set to "not ok", ignore the token.
    // Otherwise, run the following steps:
    // Remove the second element on the stack of open elements from its parent node, if it has one.
    // Pop all the nodes from the bottom of the stack of open elements, from the current node up to, but not including, the root html element.
    // Insert an HTML element for the token.
    // Switch the insertion mode to "in frameset".

    // An end-of-file token
    // If the stack of template insertion modes is not empty, then process the token using the rules for the "in template" insertion mode.
    // Otherwise, follow these steps:
    // If there is a node in the stack of open elements that is not either a dd element, a dt element, an li element, an optgroup element, an option element, a p element, an rb element, an rp element, an rt element, an rtc element, a tbody element, a td element, a tfoot element, a th element, a thead element, a tr element, the body element, or the html element, then this is a parse error.
    // Stop parsing.

        // An end tag whose tag name is "body"
        case .endTag("body", _, _):
            // If the stack of open elements does not have a body element in scope, this
            guard stack.contains(where: { $0.tagName == "body" }) else {
                // is a parse error; ignore the token.
                break
            }

            // Otherwise, if there is a node in the stack of open elements that is not
            // either a dd element, a dt element, an li element, an optgroup element,
            // an option element, a p element, an rb element, an rp element, an rt
            // element, an rtc element, a tbody element, a td element, a tfoot
            // element, a th element, a thead element, a tr element, the body element,
            // or the html element, then this is a parse error.
            let validElements = [
                "dd", "dt", "li", "optgroup", "option", "p", "rb", "rp", "rt", "rtc",
                "tbody", "td", "tfoot", "th", "thead", "tr", "body", "html",
            ]
            guard
                stack.contains(where: { element in
                    validElements.contains(element.tagName)
                })
            else {
                // This is a parse error.
                break
            }
            // Switch the insertion mode to "after body".
            insertionMode = .afterBody

        // An end tag whose tag name is "html"
        case .endTag("html", _, _):
            FIXME("endTag html")
            // If the stack of open elements does not have a body element in
            // scope, this is a parse error; ignore the token.

            // Otherwise, if there is a node in the stack of open elements that
            // is not either a dd element, a dt element, an li element, an
            // optgroup element, an option element, a p element, an rb element,
            // an rp element, an rt element, an rtc element, a tbody element, a
            // td element, a tfoot element, a th element, a thead element, a tr
            // element, the body element, or the html element, then this is a
            // parse error.

            // Switch the insertion mode to "after body".
            insertionMode = .afterBody

            // Reprocess the token.
            reprocessToken(token)

    // A start tag whose tag name is one of: "address", "article", "aside", "blockquote", "center", "details", "dialog", "dir", "div", "dl", "fieldset", "figcaption", "figure", "footer", "header", "hgroup", "main", "menu", "nav", "ol", "p", "search", "section", "summary", "ul"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token.

    // A start tag whose tag name is one of: "h1", "h2", "h3", "h4", "h5", "h6"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // If the current node is an HTML element whose tag name is one of "h1", "h2", "h3", "h4", "h5", or "h6", then this is a parse error; pop the current node off the stack of open elements.
    // Insert an HTML element for the token.

    // A start tag whose tag name is one of: "pre", "listing"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token.
    // If the next token is a U+000A LINE FEED (LF) character token, then ignore that token and move on to the next one. (Newlines at the start of pre blocks are ignored as an authoring convenience.)
    // Set the frameset-ok flag to "not ok".

    // A start tag whose tag name is "form"
    // If the form element pointer is not null, and there is no template element on the stack of open elements, then this is a parse error; ignore the token.
    // Otherwise:
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token, and, if there is no template element on the stack of open elements, set the form element pointer to point to the element created.

    // A start tag whose tag name is "li"
    // Run these steps:
    // Set the frameset-ok flag to "not ok".
    // Initialize node to be the current node (the bottommost node of the stack).
    // Loop: If node is an li element, then run these substeps:
    // Generate implied end tags, except for li elements.
    // If the current node is not an li element, then this is a parse error.
    // Pop elements from the stack of open elements until an li element has been popped from the stack.
    // Jump to the step labeled done below.
    // If node is in the special category, but is not an address, div, or p element, then jump to the step labeled done below.
    // Otherwise, set node to the previous entry in the stack of open elements and return to the step labeled loop.
    // Done: If the stack of open elements has a p element in button scope, then close a p element.
    // Finally, insert an HTML element for the token.

    // A start tag whose tag name is one of: "dd", "dt"
    // Run these steps:
    // Set the frameset-ok flag to "not ok".
    // Initialize node to be the current node (the bottommost node of the stack).
    // Loop: If node is a dd element, then run these substeps:
    // Generate implied end tags, except for dd elements.
    // If the current node is not a dd element, then this is a parse error.
    // Pop elements from the stack of open elements until a dd element has been popped from the stack.
    // Jump to the step labeled done below.
    // If node is a dt element, then run these substeps:
    // Generate implied end tags, except for dt elements.
    // If the current node is not a dt element, then this is a parse error.
    // Pop elements from the stack of open elements until a dt element has been popped from the stack.
    // Jump to the step labeled done below.
    // If node is in the special category, but is not an address, div, or p element, then jump to the step labeled done below.
    // Otherwise, set node to the previous entry in the stack of open elements and return to the step labeled loop.
    // Done: If the stack of open elements has a p element in button scope, then close a p element.
    // Finally, insert an HTML element for the token.

    // A start tag whose tag name is "plaintext"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token.
    // Switch the tokenizer to the PLAINTEXT state.
    // Once a start tag with the tag name "plaintext" has been seen, that will be the last token ever seen other than character tokens (and the end-of-file token), because there is no way to switch out of the PLAINTEXT state.

    // A start tag whose tag name is "button"
    // If the stack of open elements has a button element in scope, then run these substeps:
    // Parse error.
    // Generate implied end tags.
    // Pop elements from the stack of open elements until a button element has been popped from the stack.
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token.
    // Set the frameset-ok flag to "not ok".

    // An end tag whose tag name is one of: "address", "article", "aside", "blockquote", "button", "center", "details", "dialog", "dir", "div", "dl", "fieldset", "figcaption", "figure", "footer", "header", "hgroup", "listing", "main", "menu", "nav", "ol", "pre", "search", "section", "summary", "ul"
    // If the stack of open elements does not have an element in scope that is an HTML element with the same tag name as that of the token, then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate implied end tags.
    // If the current node is not an HTML element with the same tag name as that of the token, then this is a parse error.
    // Pop elements from the stack of open elements until an HTML element with the same tag name as the token has been popped from the stack.

    // An end tag whose tag name is "form"
    // If there is no template element on the stack of open elements, then run these substeps:
    // Let node be the element that the form element pointer is set to, or null if it is not set to an element.
    // Set the form element pointer to null.
    // If node is null or if the stack of open elements does not have node in scope, then this is a parse error; return and ignore the token.
    // Generate implied end tags.
    // If the current node is not node, then this is a parse error.
    // Remove node from the stack of open elements.
    // If there is a template element on the stack of open elements, then run these substeps instead:
    // If the stack of open elements does not have a form element in scope, then this is a parse error; return and ignore the token.
    // Generate implied end tags.
    // If the current node is not a form element, then this is a parse error.
    // Pop elements from the stack of open elements until a form element has been popped from the stack.

        // An end tag whose tag name is "p"
        case .endTag("p", _, _):
            // If the stack of open elements does not have a p element in button
            // scope, then this is a parse error; insert an HTML element for a "p"
            // start tag token with no attributes.
            if !stack.contains(where: { $0.tagName == "p" }) {
                insertHTMLElement(Token.startTag("p", attributes: []))
            }

            // Close a p element.
            FIXME("close a p element")

    // An end tag whose tag name is "li"
    // If the stack of open elements does not have an li element in list item scope, then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate implied end tags, except for li elements.
    // If the current node is not an li element, then this is a parse error.
    // Pop elements from the stack of open elements until an li element has been popped from the stack.

    // An end tag whose tag name is one of: "dd", "dt"
    // If the stack of open elements does not have an element in scope that is an HTML element with the same tag name as that of the token, then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate implied end tags, except for HTML elements with the same tag name as the token.
    // If the current node is not an HTML element with the same tag name as that of the token, then this is a parse error.
    // Pop elements from the stack of open elements until an HTML element with the same tag name as the token has been popped from the stack.

    // An end tag whose tag name is one of: "h1", "h2", "h3", "h4", "h5", "h6"
    // If the stack of open elements does not have an element in scope that is an HTML element and whose tag name is one of "h1", "h2", "h3", "h4", "h5", or "h6", then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate implied end tags.
    // If the current node is not an HTML element with the same tag name as that of the token, then this is a parse error.
    // Pop elements from the stack of open elements until an HTML element whose tag name is one of "h1", "h2", "h3", "h4", "h5", or "h6" has been popped from the stack.
    // An end tag whose tag name is "sarcasm"
    // Take a deep breath, then act as described in the "any other end tag" entry below.

    // A start tag whose tag name is "a"
    // If the list of active formatting elements contains an a element between the end of the list and the last marker on the list (or the start of the list if there is no marker on the list), then this is a parse error; run the adoption agency algorithm for the token, then remove that element from the list of active formatting elements and the stack of open elements if the adoption agency algorithm didn't already remove it (it might not have if the element is not in table scope).
    // In the non-conforming stream <a href="a">a<table><a href="b">b</table>x, the first a element would be closed upon seeing the second one, and the "x" character would be inside a link to "b", not to "a". This is despite the fact that the outer a element is not in table scope (meaning that a regular </a> end tag at the start of the table wouldn't close the outer a element). The result is that the two a elements are indirectly nested inside each other — non-conforming markup will often result in non-conforming DOMs when parsed.
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token. Push onto the list of active formatting elements that element.

    // A start tag whose tag name is one of: "b", "big", "code", "em", "font", "i", "s", "small", "strike", "strong", "tt", "u"
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token. Push onto the list of active formatting elements that element.

    // A start tag whose tag name is "nobr"
    // Reconstruct the active formatting elements, if any.
    // If the stack of open elements has a nobr element in scope, then this is a parse error; run the adoption agency algorithm for the token, then once again reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token. Push onto the list of active formatting elements that element.

    // An end tag whose tag name is one of: "a", "b", "big", "code", "em", "font", "i", "nobr", "s", "small", "strike", "strong", "tt", "u"
    // Run the adoption agency algorithm for the token.
    // A start tag whose tag name is one of: "applet", "marquee", "object"
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token.
    // Insert a marker at the end of the list of active formatting elements.
    // Set the frameset-ok flag to "not ok".

    // An end tag token whose tag name is one of: "applet", "marquee", "object"
    // If the stack of open elements does not have an element in scope that is an HTML element with the same tag name as that of the token, then this is a parse error; ignore the token.
    // Otherwise, run these steps:
    // Generate implied end tags.
    // If the current node is not an HTML element with the same tag name as that of the token, then this is a parse error.
    // Pop elements from the stack of open elements until an HTML element with the same tag name as the token has been popped from the stack.
    // Clear the list of active formatting elements up to the last marker.

    // A start tag whose tag name is "table"
    // If the Document is not set to quirks mode, and the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token.
    // Set the frameset-ok flag to "not ok".
    // Switch the insertion mode to "in table".

    // An end tag whose tag name is "br"
    // Parse error. Drop the attributes from the token, and act as described in the next entry; i.e. act as if this was a "br" start tag token with no attributes, rather than the end tag token that it actually is.

    // A start tag whose tag name is one of: "area", "br", "embed", "img", "keygen", "wbr"
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
    // Acknowledge the token's self-closing flag, if it is set.
    // Set the frameset-ok flag to "not ok".

    // A start tag whose tag name is "input"
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
    // Acknowledge the token's self-closing flag, if it is set.
    // If the token does not have an attribute with the name "type", or if it does, but that attribute's value is not an ASCII case-insensitive match for the string "hidden", then: set the frameset-ok flag to "not ok".

    // A start tag whose tag name is one of: "param", "source", "track"
    // Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
    // Acknowledge the token's self-closing flag, if it is set.

    // A start tag whose tag name is "hr"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
    // Acknowledge the token's self-closing flag, if it is set.
    // Set the frameset-ok flag to "not ok".

    // A start tag whose tag name is "image"
    // Parse error. Change the token's tag name to "img" and reprocess it. (Don't ask.)

    // A start tag whose tag name is "textarea"
    // Run these steps:
    // Insert an HTML element for the token.
    // If the next token is a U+000A LINE FEED (LF) character token, then ignore that token and move on to the next one. (Newlines at the start of textarea elements are ignored as an authoring convenience.)
    // Switch the tokenizer to the RCDATA state.
    // Let the original insertion mode be the current insertion mode.
    // Set the frameset-ok flag to "not ok".
    // Switch the insertion mode to "text".

    // A start tag whose tag name is "xmp"
    // If the stack of open elements has a p element in button scope, then close a p element.
    // Reconstruct the active formatting elements, if any.
    // Set the frameset-ok flag to "not ok".
    // Follow the generic raw text element parsing algorithm.

    // A start tag whose tag name is "iframe"
    // Set the frameset-ok flag to "not ok".
    // Follow the generic raw text element parsing algorithm.

    // A start tag whose tag name is "noembed"

    // A start tag whose tag name is "noscript", if the scripting flag is enabled
    // Follow the generic raw text element parsing algorithm.

    // A start tag whose tag name is "select"
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token.
    // Set the frameset-ok flag to "not ok".
    // If the insertion mode is one of "in table", "in caption", "in table body", "in row", or "in cell", then switch the insertion mode to "in select in table". Otherwise, switch the insertion mode to "in select".

    // A start tag whose tag name is one of: "optgroup", "option"
    // If the current node is an option element, then pop the current node off the stack of open elements.
    // Reconstruct the active formatting elements, if any.
    // Insert an HTML element for the token.

    // A start tag whose tag name is one of: "rb", "rtc"
    // If the stack of open elements has a ruby element in scope, then generate implied end tags. If the current node is not now a ruby element, this is a parse error.
    // Insert an HTML element for the token.

    // A start tag whose tag name is one of: "rp", "rt"
    // If the stack of open elements has a ruby element in scope, then generate implied end tags, except for rtc elements. If the current node is not now a rtc element or a ruby element, this is a parse error.
    // Insert an HTML element for the token.

    // A start tag whose tag name is "math"
    // Reconstruct the active formatting elements, if any.
    // Adjust MathML attributes for the token. (This fixes the case of MathML attributes that are not all lowercase.)
    // Adjust foreign attributes for the token. (This fixes the use of namespaced attributes, in particular XLink.)
    // Insert a foreign element for the token, with MathML namespace and false.
    // If the token has its self-closing flag set, pop the current node off the stack of open elements and acknowledge the token's self-closing flag.

    // A start tag whose tag name is "svg"
    // Reconstruct the active formatting elements, if any.
    // Adjust SVG attributes for the token. (This fixes the case of SVG attributes that are not all lowercase.)
    // Adjust foreign attributes for the token. (This fixes the use of namespaced attributes, in particular XLink in SVG.)
    // Insert a foreign element for the token, with SVG namespace and false.
    // If the token has its self-closing flag set, pop the current node off the stack of open elements and acknowledge the token's self-closing flag.

    // A start tag whose tag name is one of: "caption", "col", "colgroup", "frame", "head", "tbody", "td", "tfoot", "th", "thead", "tr"
    // Parse error. Ignore the token.

        // Any other start tag
        case let .startTag(_, _, isSelfClosing):
            // Reconstruct the active formatting elements, if any.
            reconstructActiveFormattingElements()
            // Insert an HTML element for the token.
            insertHTMLElement(token)
            // If the token has its self-closing flag set, pop the current node off the stack of open elements and acknowledge the token's self-closing flag.
            if isSelfClosing {
                stack.removeLast()
                acknowledgeTokenSelfClosingFlag()
            }
    // This element will be an ordinary element. With one exception: if the
    // scripting flag is disabled, it can also be a noscript element.

        // Any other end tag
        case let .endTag(tagName, _, _):
            // Initialize node to be the current node (the bottommost node of the stack).
            let node = currentNode

            // Loop: If node is an HTML element with the same tag name as the token, then:
            while let element = node as? Element, element.localName == tagName {
                // Generate implied end tags, except for HTML elements with the same tag name as the token.
                // generateImpliedEndTags(exceptFor: token.tagName)

                // If node is not the current node, then this is a parse error.
                if node != currentNode {
                    // Parse error.
                    break
                }

                // Pop elements from the stack of open elements until node has been popped from the stack.
                var removedNode: Node?
                while removedNode != node {
                    removedNode = stack.removeLast()
                }
                break
            }
            // Otherwise, if node is in the special category, then this is a
            // parse error; ignore the token, and return. Set node to the
            // previous entry in the stack of open elements. Return to the step
            // labeled loop.

        default:
            break
        }
    }
}

// When the steps above say the user agent is to close a p element, it means that the user agent must run the following steps:
// Generate implied end tags, except for p elements.
// If the current node is not a p element, then this is a parse error.
// Pop elements from the stack of open elements until a p element has been popped from the stack.
// The adoption agency algorithm, which takes as its only argument a token token for which the algorithm is being run, consists of the following steps:
// Let subject be token's tag name.
// If the current node is an HTML element whose tag name is subject, and the current node is not in the list of active formatting elements, then pop the current node off the stack of open elements and return.
// Let outerLoopCounter be 0.
// While true:
// If outerLoopCounter is greater than or equal to 8, then return.
// Increment outerLoopCounter by 1.
// Let formattingElement be the last element in the list of active formatting elements that:
// is between the end of the list and the last marker in the list, if any, or the start of the list otherwise, and
// has the tag name subject.
// If there is no such element, then return and instead act as described in the "any other end tag" entry above.
// If formattingElement is not in the stack of open elements, then this is a parse error; remove the element from the list, and return.
// If formattingElement is in the stack of open elements, but the element is not in scope, then this is a parse error; return.
// If formattingElement is not the current node, this is a parse error. (But do not return.)
// Let furthestBlock be the topmost node in the stack of open elements that is lower in the stack than formattingElement, and is an element in the special category. There might not be one.
// If there is no furthestBlock, then the UA must first pop all the nodes from the bottom of the stack of open elements, from the current node up to and including formattingElement, then remove formattingElement from the list of active formatting elements, and finally return.
// Let commonAncestor be the element immediately above formattingElement in the stack of open elements.
// Let a bookmark note the position of formattingElement in the list of active formatting elements relative to the elements on either side of it in the list.
// Let node and lastNode be furthestBlock.
// Let innerLoopCounter be 0.
// While true:
// Increment innerLoopCounter by 1.
// Let node be the element immediately above node in the stack of open elements, or if node is no longer in the stack of open elements (e.g. because it got removed by this algorithm), the element that was immediately above node in the stack of open elements before node was removed.
// If node is formattingElement, then break.
// If innerLoopCounter is greater than 3 and node is in the list of active formatting elements, then remove node from the list of active formatting elements.
// If node is not in the list of active formatting elements, then remove node from the stack of open elements and continue.
// Create an element for the token for which the element node was created, in the HTML namespace, with commonAncestor as the intended parent; replace the entry for node in the list of active formatting elements with an entry for the new element, replace the entry for node in the stack of open elements with an entry for the new element, and let node be the new element.
// If last node is furthestBlock, then move the aforementioned bookmark to be immediately after the new node in the list of active formatting elements.
// Append lastNode to node.
// Set lastNode to node.
// Insert whatever lastNode ended up being in the previous step at the appropriate place for inserting a node, but using commonAncestor as the override target.
// Create an element for the token for which formattingElement was created, in the HTML namespace, with furthestBlock as the intended parent.
// Take all of the child nodes of furthestBlock and append them to the element created in the last step.
// Append that new element to furthestBlock.
// Remove formattingElement from the list of active formatting elements, and insert the new element into the list of active formatting elements at the position of the aforementioned bookmark.
// Remove formattingElement from the stack of open elements, and insert the new element into the stack of open elements immediately below the position of furthestBlock in that stack.
// This algorithm's name, the "adoption agency algorithm", comes from the way it causes elements to change parents, and is in contrast with other possible algorithms for dealing with misnested content.
