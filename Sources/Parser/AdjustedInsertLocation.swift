struct AdjustedInsertionLocation {
    var node: Node?
    var afterSibling: Element? = nil

    func insert(_ child: Node) {
        if let afterSibling = afterSibling {
            afterSibling.after(child)
        } else {
            node!.appendChild(child)
        }
    }
}
