struct AdjustedInsertionLocation {
  var node: Node?
  var afterSibling: Node? = nil

  func insert(_ child: Node) {
    if let afterSibling = afterSibling {
      node?.insertBefore(child, before: afterSibling)
    } else {
      node?.appendChild(child)
    }
  }
  
}
