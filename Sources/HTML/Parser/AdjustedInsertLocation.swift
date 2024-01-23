struct AdjustedInsertionLocation {
    var parent: Node?
    var insertBeforeSibling: Node? = nil

    func insert(_ child: Node) {
        parent!.insertBefore(node: child, before: insertBeforeSibling)
    }
}
