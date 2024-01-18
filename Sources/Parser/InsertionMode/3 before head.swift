extension TreeBuilder {

  // 13.2.6.4.3 The "before head" insertion mode
  // https://html.spec.whatwg.org/multipage/parsing.html#the-before-head-insertion-mode
  func handlebeforeHead(_ token: Token) {
    switch token {
  
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

    // A comment token
    case .comment(let comment):
      // Insert a comment.
      self.insertAComment(comment)

    // A DOCTYPE token
    case .doctype:
      // Parse error. Ignore the token.
      break

    // A start tag whose tag name is "html"
    case .startTag("html", attributes: _, isSelfClosing: _):
      // Process the token using the rules for the "in body" insertion mode.
      self.insertionMode = .inBody
      self.handleInBody(token)

    // A start tag whose tag name is "head"
    case .startTag("head", attributes: _, isSelfClosing: _):
      // Insert an HTML element for the token.
      self.insertHTMLElement(token)

      // Switch the insertion mode to "in head".
      self.insertionMode = .inHead

    // An end tag whose tag name is one of: "head", "body", "html", "br"
    case .endTag(let tagName, _, _):
      if tagName == "head" || tagName == "body" || tagName == "html" || tagName == "br" {
        // Act as described in the "anything else" entry below.
        fallthrough
      }
      // Any other end tag
      else {
        // Parse error. Ignore the token.
        break
      }

    // Anything else
    default:
      // Insert an HTML element for a "head" start tag token with no attributes.
      _ = insertHTMLElement(token)

      // Switch the insertion mode to "in head".
      self.insertionMode = .inHead

      // Reprocess the current token.
      self.handleInHead(token)
    }
  }

}
