extension TreeBuilder {

  // 13.2.6.4.2 The "before html" insertion mode
  // https://html.spec.whatwg.org/multipage/parsing.html#the-before-html-insertion-mode
  func handlebeforeHtml(_ token: Token) {
    switch token {

    // A DOCTYPE token
    case .doctype:
      // Parse error. Ignore the token.
      break

    // A comment token
    case .comment(let comment):
      // Insert a comment as the last child of the Document object.
      self.insertAComment(comment)

    // A character token that is one of
    // - U+0009 CHARACTER TABULATION,
    // - U+000A LINE FEED (LF),
    // - U+000C FORM FEED (FF),
    // - U+000D CARRIAGE RETURN (CR), or
    // - U+0020 SPACE
    case .character(let c)
    where c == "\u{0009}" || c == "\u{000A}" || c == "\u{000C}" || c == "\u{000D}"
      || c == "\u{0020}":
      // Ignore the token.
      break

    // A start tag whose tag name is "html"
    case .startTag("html", attributes: _, isSelfClosing: _):
      // Create an element for the token in the HTML namespace, with the
      // Document as the intended parent. 
      let element = createElementForToken(token: token, namespace: HTML_NS, intendedParent: document )

      // Append it to the Document object.
      document.appendChild(element)

      // Put this element in the stack of open elements.
      stack.append(element)

      // Switch the insertion mode to "before head".
      self.insertionMode = .beforeHead

    // An end tag whose tag name is one of: "head", "body", "html", "br"
    case .endTag(let tagName, _, _):
      if tagName == "head" || tagName == "body" || tagName == "html" || tagName == "br" {
        // Act as described in the "anything else" entry below.
        fallthrough
        // Any other end tag
      } else {
        // Parse error. Ignore the token.
        break
      }

    // Anything else
    default:
      // Create an html element whose node document is the Document object.
      let element = Element(localName: "", namespace: HTML_NS, nodeDocument: document)

      // Append it to the Document object. 
      document.appendChild(element)

      // Put this element in the stack of open elements.
      stack.append(element)

      // Switch the insertion mode to "before head", then reprocess the token.
      self.insertionMode = .beforeHead

    }

    // The document element can end up being removed from the Document object,
    // e.g. by scripts; nothing in particular happens in such cases, content
    // continues being appended to the nodes as described in the next section.

  }
  
}