struct AdjustedInsertionLocation {
    var parent: DOM.Node?
    var insertBeforeSibling: DOM.Node?

    func insert(_ child: DOM.Node) {
        parent!.insertBefore(node: child, before: insertBeforeSibling)
    }
}
