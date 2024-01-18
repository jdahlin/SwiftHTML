extension TreeBuilder {

  // 13.2.6.4.1 The "initial" insertion mode
  // https://html.spec.whatwg.org/multipage/parsing.html#the-initial-insertion-mode
  func handleInitial(_ token: Token) {
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
      // Insert a comment as the last child of the Document object.
      self.insertAComment(comment)

    // A DOCTYPE token
    case .doctype(let name, let publicId, let systemId, _):
      // Append a DocumentType node to the Document node, with its name set to the
      // name given in the DOCTYPE token, or the empty string if the name was
      // missing; its public ID set to the public identifier given in the DOCTYPE
      // token, or the empty string if the public identifier was missing; and its
      // system ID set to the system identifier given in the DOCTYPE token, or the
      // empty string if the system identifier was missing.
      guard name == "html" else {
        print("doctype: non html not implemented")
        exit(0)
        break
      }
      let doctypeNode = DocumentType(name: name, publicId: publicId, systemId: systemId)
      document.appendChild(doctypeNode)
      // Then, if the document is not an iframe srcdoc document, and the parser
      // cannot change the mode flag is false, and the DOCTYPE token matches one
      // of the conditions in the following list, then set the Document to
      // quirks mode:
      document.mode = .quirks

      // Otherwise, if the document is not an iframe srcdoc document, and the parser cannot change the mode flag is false, and the DOCTYPE token matches one of the conditions in the following list, then then set the Document to limited-quirks mode:

      // The public identifier starts with: "-//W3C//DTD XHTML 1.0 Frameset//"
      // The public identifier starts with: "-//W3C//DTD XHTML 1.0 Transitional//"
      // The system identifier is not missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Frameset//"
      // The system identifier is not missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Transitional//"
      // The system identifier and public identifier strings must be compared to the values given in the lists above in an ASCII case-insensitive manner. A system identifier whose value is the empty string is not considered missing for the purposes of the conditions above.

      // Then, switch the insertion mode to "before html".


    // Anything else
    default:
      // If the document is not an iframe srcdoc document, then this is a
      // parse error; if the parser cannot change the mode flag is false, set
      // the Document to quirks mode.
      // In any case, switch the insertion mode to "before html", then
      // reprocess the token.
      self.insertionMode = .beforeHTML
    }
  }

}
