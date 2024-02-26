enum Painting {}

extension Painting {
    class Paintable {
        var domNode: DOM.Node?
        var layoutNode: Layout.Node?
        var children: [Paintable] = []

        init(layoutNode: Layout.Node) {
            self.layoutNode = layoutNode
            domNode = layoutNode.domNode
        }

        func containingBlock() -> Layout.Box? {
            layoutNode?.containingBlock()
        }

        func formsUnconnectedSubTree() -> Bool {
            false
        }

        func appendChild(_ paintable: Paintable) {
            children.append(paintable)
        }
    }
}
