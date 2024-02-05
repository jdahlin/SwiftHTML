extension Layout {
    class NodeWithStyle: Node {
        var computedValues: CSS.ComputedValues

        init(document: DOM.Document,
             domNode: DOM.Node?,
             style: CSS.StyleProperties)
        {
            computedValues = CSS.ComputedValues()
            super.init(document: document, domNode: domNode)
            hasStyle = true
            applyStyle(style: style)
        }

        init(document: DOM.Document,
             domNode: DOM.Node?,
             computedValues: CSS.ComputedValues)
        {
            self.computedValues = computedValues
            super.init(document: document, domNode: domNode)
            hasStyle = true
        }

        func applyStyle(style: CSS.StyleProperties) {
            computedValues.color = style.color.color(fallback: CSS.InitialValues.color)!
            computedValues.display = style.display.display()
        }

        func hasInFlowBlockChildren() -> Bool {
            children.contains {
                if case let node as NodeWithStyle = $0 {
                    return node.display.isFlow()
                }
                return false
            }
        }

        func createAnonymousWrapper() -> BlockContainer {
            BlockContainer(
                document: document,
                domNode: nil,
                computedValues: computedValues.cloneInheritedValues()
            )
        }
    }
}

extension Layout.Node {
    func printTree(indent: String = "") {
        var extra = ""
        if isAnonymous() {
            extra += " (anonymous)"
        } else {
            extra += " " + String(describing: domNode)
        }

        print("\(indent)\(type(of: self))\(extra)")
        for child in children {
            child.printTree(indent: indent + "  ")
        }
    }
}
