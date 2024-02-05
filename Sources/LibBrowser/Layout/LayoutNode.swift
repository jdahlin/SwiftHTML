extension Layout {
    class Node {
        let document: DOM.Document
        let domNode: DOM.Node?
        var children: [Node] = []
        var childrenAreInline = false
        var hasStyle: Bool = false

        init(document: DOM.Document, domNode: DOM.Node?) {
            self.document = document
            self.domNode = domNode
        }

        func appendChild(_ child: Node) {
            children.append(child)
        }

        func prependChild(_ child: Node) {
            children.insert(child, at: 0)
        }

        func isAnonymous() -> Bool {
            domNode != nil
        }

        func isGenerated() -> Bool {
            // FIXME: pseudo
            false
        }

        var display: CSS.Display {
            if let nodeWithStyle = self as? NodeWithStyle {
                return nodeWithStyle.computedValues.display
            }
            return CSS.Display(outer: .inline, inner: .flow)
        }
    }
}
