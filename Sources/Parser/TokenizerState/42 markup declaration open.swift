extension Tokenizer {

  // 13.2.5.42 Markup declaration open state 
  // https://html.spec.whatwg.org/multipage/parsing.html#markup-declaration-open-state
  func handleMarkupDeclarationOpenState() {
    
    // If the next few characters are:
    switch self.consumeNextInputCharacter() {

    // U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN (-->)
    case "-":
      if self.data.count > self.position + 1,
        self.data[self.position + 1] == UInt8(ascii: "-")
      {
        // Consume them.
        self.position += 1
        // Create a comment token whose data is the empty string. Switch to the comment start state.
        self.currentToken = .comment("")
        self.state = .commentStart
        return
      }

    // ASCII case-insensitive match for the word "DOCTYPE"
    case "D", "d":
      if self.data.count > self.position + 6,
        self.data[self.position + 1] == UInt8(ascii: "O")
          || self.data[self.position + 1] == UInt8(ascii: "o"),
        self.data[self.position + 2] == UInt8(ascii: "C")
          || self.data[self.position + 2] == UInt8(ascii: "c"),
        self.data[self.position + 3] == UInt8(ascii: "T")
          || self.data[self.position + 3] == UInt8(ascii: "t"),
        self.data[self.position + 4] == UInt8(ascii: "Y")
          || self.data[self.position + 4] == UInt8(ascii: "y"),
        self.data[self.position + 5] == UInt8(ascii: "P")
          || self.data[self.position + 5] == UInt8(ascii: "p"),
        self.data[self.position + 6] == UInt8(ascii: "E")
          || self.data[self.position + 6] == UInt8(ascii: "e")
      {
        // Consume those characters and switch to the DOCTYPE state.
        self.position += 6
        self.state = .doctype
        return
      }

    // The string "[CDATA[" (the five uppercase letters "CDATA" with a U+005B
    // LEFT SQUARE BRACKET character before and after)
    case "[":
      if self.data.count > self.position + 6,
        self.data[self.position + 1] == UInt8(ascii: "C"),
        self.data[self.position + 2] == UInt8(ascii: "D"),
        self.data[self.position + 3] == UInt8(ascii: "A"),
        self.data[self.position + 4] == UInt8(ascii: "T"),
        self.data[self.position + 5] == UInt8(ascii: "A"),
        self.data[self.position + 6] == UInt8(ascii: "[")
      {
        // Consume those characters. If there is an adjusted current node and it
        // is not an element in the HTML namespace, then switch to the CDATA
        // section state. Otherwise, this is a cdata-in-html-content parse
        // error. Create a comment token whose data is the "[CDATA[" string.
        // Switch to the bogus comment state.
        self.position += 6
        // FIXME: if let adjustedCurrentNode = self.adjustedCurrentNode, !adjustedCurrentNode.isHTMLElement() {
        //           self.state = .cdataSection
        self.currentToken = .comment("[CDATA[")
        self.state = .bogusComment
        return
      }

    default:
      break
    }

    // Anything else
    // This is an incorrectly-opened-comment parse error. Create a comment token
    // whose data is the empty string. Switch to the bogus comment state (don't
    // consume anything in the current state).
    self.currentToken = .comment("")
    self.state = .bogusComment
  }

}