import CoreText

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
            computedValues.apply(style: style)
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

        func firstAvailableFont() -> CTFont {
            let font = CTFontCreateUIFontForLanguage(.system, 12, nil)
            return font!
        }
    }
}

extension Layout.Node {
    func printTree(indent: String = "") {
        var extra = ""
        if let domNode {
            extra += " \(domNode.nodeName ?? "")"
        } else {
            extra += " (anonymous)"
        }
        print("\(indent)\(type(of: self))\(extra)")
        for child in children {
            child.printTree(indent: indent + "  ")
        }
    }
}

extension Layout.Node: Hashable {
    static func == (lhs: Layout.Node, rhs: Layout.Node) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}
