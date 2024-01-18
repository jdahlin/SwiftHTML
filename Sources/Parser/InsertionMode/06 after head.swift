extension TreeBuilder {

  // 13.2.6.4.6 The "after head" insertion mode
  func handleAfterHead(_ token: Token) {

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
      // Insert the character.
      self.insertACharachter([c])

    // A comment token
    case .comment(let comment):
      // Insert a comment.
      self.insertAComment(comment)

    // A DOCTYPE token
    case .doctype:
      // Parse error. Ignore the token.
      break

    // A start tag whose tag name is "html"
    case .startTag("html", attributes: _, _):
      // Process the token using the rules for the "in body" insertion mode.
      self.handleInBody(token)

    // A start tag whose tag name is "body"
    case .startTag("body", attributes: _, _):
      // Insert an HTML element for the token.
      self.insertHTMLElement(token)
      // Set the frameset-ok flag to "not ok".
      self.framesetOkFlag = .notOk
      // Switch the insertion mode to "in body".
      self.insertionMode = .inBody

    // A start tag whose tag name is "frameset"
    case .startTag("frameset", attributes: _, _):
      // Insert an HTML element for the token.
      self.insertHTMLElement(token)
      // Switch the insertion mode to "in frameset".
      self.insertionMode = .inFrameset

    // A start tag whose tag name is one of: "base", "basefont", "bgsound", "link", "meta", "noframes", "script", "style", "template", "title"
    case .startTag(_, attributes: _, _):
      // Parse error.
      // self.parseError("Unexpected start tag '\(tagName)' in 'in head' insertion mode.")
      // Push the node pointed to by the head element pointer onto the stack of open elements.
      self.stack.append(self.headElementPointer!)
      // Process the token using the rules for the "in head" insertion mode.
      self.handleInHead(token)
      // Remove the node pointed to by the head element pointer from the stack of open elements.
      // (It might not be the current node at this point.)
      if let index = self.stack.lastIndex(of: self.headElementPointer!) {
        self.stack.remove(at: index)
      }
      // The head element pointer cannot be null at this point.
      assert(self.headElementPointer != nil)

    // An end tag whose tag name is "template"
    case .endTag("template", _, _):
      // Process the token using the rules for the "in head" insertion mode.
      self.handleInHead(token)

    // An end tag whose tag name is one of: "body", "html", "br"
    case .endTag(let tagName, _, _) where tagName == "body" || tagName == "html" || tagName == "br":
      // Act as described in the "anything else" entry below.

      // Insert an HTML element for a "body" start tag token with no attributes.
      self.insertHTMLElement(Token.startTag("body", attributes: []))
      // Switch the insertion mode to "in body".
      self.insertionMode = .inBody
      // Reprocess the current token.
      self.handleInBody(token)

    // A start tag whose tag name is "head"
    case .startTag("head", _, _):
      // Parse error. Ignore the token.
      break

    // Any other end tag
    case .endTag:
      // Parse error. Ignore the token.
      break

    // Anything else
    default:
      // Insert an HTML element for a "body" start tag token with no attributes.
      self.insertHTMLElement(Token.startTag("body", attributes: []))
      // Switch the insertion mode to "in body".
      self.insertionMode = .inBody
      // Reprocess the current token.
      self.handleInBody(token)
    }
  }

}
