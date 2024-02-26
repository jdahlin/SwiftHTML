enum Painting {}

extension Painting {
    class Paintable {
        var domNode: DOM.Node?
        var layoutNode: Layout.Node?

        init(layoutNode: Layout.Node) {
            self.layoutNode = layoutNode
            domNode = layoutNode.domNode
        }

        func containingBlock() -> Layout.Box? {
            layoutNode?.containingBlock()
        }
    }
}
