import Foundation

enum InsertionMode {
  case initial
  case beforeHTML
  case beforeHead
  case inHead
  case inHeadNoscript
  case afterHead
  case inBody
  case text
  case inTable
  case inTableText
  case inCaption
  case inColumnGroup
  case inTableBody
  case inRow
  case inCell
  case inSelect
  case inSelectInTable
  case inTemplate
  case afterBody
  case inFrameset
  case afterFrameset
  case afterAfterBody
  case afterAfterFrameset
}

enum DocumentMode {
  case noQuirks
  case quirks
  case limitedQuirks
}

enum FramesetFlag {
  case ok
  case notOk
}

class TreeBuilder: TokenReceiver {
  var tokenizer: Tokenizer
  var document: Document = Document()
  var stack: [Element] = []
  var insertionMode: InsertionMode = .initial
  var fosterParenting = false
  var activeSpeculativeHTMLParser: TreeBuilder? = nil
  var scriptingFlag = true
  var framesetOkFlag: FramesetFlag = .ok
  var headElementPointer: Element?
  var formElementPointer: Element?
  var isFragmentParsing = false

  // https://html.spec.whatwg.org/multipage/parsing.html#original-insertion-mode
  // When the insertion mode is switched to "text" or "in table text", the
  // original insertion mode is also set. This is the insertion mode to which
  // the tree construction stage will return.
  var originalInsertionMode: InsertionMode?

  init(tokenizer: Tokenizer) {
    self.tokenizer = tokenizer
    self.tokenizer.delegate = self
  }

  func didReceiveToken(_ token: Token) {
    print("\(#function): \(insertionMode) \(token)")
    handleToken(token)
  }

  // https://html.spec.whatwg.org/multipage/parsing.html#current-node
  var currentNode: Node {
    return stack.last!
  }

  // https://html.spec.whatwg.org/multipage/parsing.html#appropriate-place-for-inserting-a-node
  func appropriatePlaceForInsertingANode(overrideTarget: Node? = nil) -> AdjustedInsertionLocation {
    // If there was an override target specified, then let target be the override target.
    var target = overrideTarget

    // Otherwise, let target be the current node.
    if target == nil {
      target = self.currentNode
    }

    // 2. Determine the adjusted insertion location using the first matching steps from the following list:

    // FIXME: If foster parenting is enabled and target is a table, tbody, tfoot, thead, or tr element
    // Foster parenting happens when content is misnested in tables.

    // Run these substeps:
    // 2.1. Let last template be the last template element in the stack of open elements, if any.
    // 2.2. Let last table be the last table element in the stack of open elements, if any.

    // 2.3. If there is a last template and either there is no last table, or
    //      there is one, but last template is lower (more recently added) than
    //      last table in the stack of open elements, then: let adjusted
    //      insertion location be inside last template's template contents,
    //      after its last child (if any), and abort these steps.

    // 2.4. If there is no last table, then let adjusted insertion location be
    //      inside the first element in the stack of open elements (the html
    //      element), after its last child (if any), and abort these steps.
    //      (fragment case)

    // 2.5. If last table has a parent node, then let adjusted insertion
    //      location be inside last table's parent node, immediately before last
    //      table, and abort these steps.

    // 2.6. Let previous element be the element immediately above last table in the stack of open elements.

    // 2.7 Let adjusted insertion location be inside previous element, after its last child (if any).

    if self.fosterParenting {
      print("FIXME: foster parenting not implemented")
    }
    // Otherwise
    // Let adjusted insertion location be inside target, after its last child (if any).
    let adjustedInsertionLocation = AdjustedInsertionLocation(
      node: target, afterSibling: target!.lastChild)

    // FIXME: 3. If the adjusted insertion location is inside a template element,
    // let it instead be inside the template element's template contents, after its last child (if any).

    // 4. Return the adjusted insertion location.
    return adjustedInsertionLocation
  }

  // https://html.spec.whatwg.org/multipage/parsing.html#insert-a-character
  func insertACharachter(_ data: [Character]? = nil) {
    // 1. Let data be the characters passed to the algorithm, or, if no
    //    characters were explicitly specified, the character of the character
    //    token being processed.

    // 2. Let the adjusted insertion location be the appropriate place for
    //    inserting a node.
    let adjustedInsertionLocation = appropriatePlaceForInsertingANode()

    // 3. If the adjusted insertion location is in a Document node, then return.
    if adjustedInsertionLocation.node is Document {
      return
    }

    // FIXME 4. If there is a Text node immediately before the adjusted insertion
    //    location, then append data to that Text node's data.
    if let previousSibling = adjustedInsertionLocation.node?.lastChild,
       previousSibling is Text {
      let textNode = previousSibling as! Text
      textNode.data += DOMString(data!)
    // 5. Otherwise, create a new Text node whose data is data and whose node
    //    document is the same as that of the node in which the adjusted insertion
    //    location finds itself, and insert the newly created node at the adjusted insertion location.
    } else {
      let textNode = Text()
      textNode.data = DOMString(data!)
      textNode.ownerDocument = adjustedInsertionLocation.node?.ownerDocument
      adjustedInsertionLocation.insert(textNode)
    }

  }

  // https://html.spec.whatwg.org/multipage/parsing.html#insert-a-comment
  func insertAComment(_ data: String, position: AdjustedInsertionLocation? = nil) {
    // 1. Let data be the data given in the comment token being processed.

    // 2. If position was specified, then let the adjusted insertion location be
    //    position. Otherwise, let adjusted insertion location be the appropriate place
    //    for inserting a node.
    if position != nil {
      print("\(#function): position not implemented")
    }
    let adjustedInsertionLocation = appropriatePlaceForInsertingANode()

    // 3. Create a Comment node whose data attribute is set to data and whose node
    //    document is the same as that of the node in which the adjusted insertion
    //    location finds itself.
    let commentNode = Comment()
    commentNode.data = DOMString(data)
    commentNode.ownerDocument = adjustedInsertionLocation.node?.ownerDocument

    // 4. Insert the newly created node at the adjusted insertion location.
    adjustedInsertionLocation.insert(commentNode)
  }


// https://html.spec.whatwg.org/multipage/parsing.html#insert-a-foreign-element
// Note: If the adjusted insertion location cannot accept more elements, e.g.,
//       because it's a Document that already has an element child, then element is
//       dropped on the floor.
func insertForeignElement(token: Token, namespace: String, onlyAddElementToStack: Bool) -> Element
  {
    // Let the adjusted insertion location be the appropriate place for inserting a node.
    let appropriatePlaceForInsertingANode = self.appropriatePlaceForInsertingANode()

    // Let element be the result of creating an element for the token in the
    // given namespace, with the intended parent being the element in which the
    // adjusted insertion location finds itself.
    let intendedParent = appropriatePlaceForInsertingANode.node! as! Element
    let element = createElementForToken(
      token: token, 
      namespace: HTML_NS,
      intendedParent: intendedParent)

    // If onlyAddToElementStack is false, then run insert an element at the
    // adjusted insertion location with element.
    if !onlyAddElementToStack {
      appropriatePlaceForInsertingANode.insert(element)
    }

    // Push element onto the stack of open elements so that it is the new current node.
    self.stack.append(element)

    // Return element.
    return element
  }

  // https://html.spec.whatwg.org/multipage/parsing.html#insert-an-html-element
  @discardableResult
  func insertHTMLElement(_ token: Token) -> Element {
    // When the steps below require the user agent to insert an HTML element for
    // a token, the user agent must insert a foreign element for the token, with
    // the HTML namespace and false.
    return insertForeignElement(
      token: token,
      namespace: HTML_NS,
      onlyAddElementToStack: false
    )
  }

  func reconstructActiveFormattingElements() {}
  func acknowledgeTokenSelfClosingFlag() {}

  func handleToken(_ token: Token) {
    // Handle the token
    switch self.insertionMode {
    case .initial:
      handleInitial(token)
    case .beforeHTML:
      handlebeforeHtml(token)
    case .beforeHead:
      handlebeforeHead(token)
    case .afterHead:
      handleAfterHead(token)
    case .inHead:
      handleInHead(token)
    case .inBody:
      handleInBody(token)
    default:
      print("Unknown insertion mode: \(self.insertionMode)")
      exit(0)
    }
  }

}
