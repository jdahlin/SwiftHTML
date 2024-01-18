struct AdjustedInsertionLocation {
  var node: Node?
  var afterSibling: Node? = nil

  func insert(_ node: Node) {
    if let afterSibling = self.afterSibling {
      self.node?.insertBefore(node, before: afterSibling)
    } else {
      self.node?.appendChild(node)
    }
  }
  
}
