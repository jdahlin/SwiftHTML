import CoreText

extension Layout {
    class NodeWithStyle: Node {
        var computedValues: CSS.ComputedValues

        init(document: DOM.Document,
             domNode: DOM.Node?,
             computedStyle: CSS.StyleProperties)
        {
            computedValues = CSS.ComputedValues()
            super.init(document: document, domNode: domNode)
            hasStyle = true
            applyStyle(computedStyle: computedStyle)
        }

        init(document: DOM.Document,
             domNode: DOM.Node?,
             computedValues: CSS.ComputedValues)
        {
            self.computedValues = computedValues
            super.init(document: document, domNode: domNode)
            hasStyle = true
        }

        func applyStyle(computedStyle: CSS.StyleProperties) {
            print(domNode, computedStyle.toStringDict())

            computedValues.backgroundColor = computedStyle.backgroundColor ?? CSS.InitialValues.backgroundColor
            computedValues.color = computedStyle.color ?? CSS.InitialValues.color
            if let display = computedStyle.display {
                computedValues.display = display
            }
            if let height = computedStyle.height {
                computedValues.height = height
            }
            if let width = computedStyle.width {
                computedValues.width = width
            }
            if let fontSize = computedStyle.fontSize {
                computedValues.fontSize = fontSize.length().toPx(layoutNode: self)
            }
            computedValues.inset = computedStyle.lengthBox(leftId: .left, rightId: .right, topId: .top, bottomId: .bottom, fallback: .auto)
            computedValues.margin = computedStyle.lengthBox(leftId: .marginLeft, rightId: .marginRight, topId: .marginTop, bottomId: .marginBottom, fallback: .length(.absolute(.px(0))))
            computedValues.padding = computedStyle.lengthBox(leftId: .paddingLeft, rightId: .paddingRight, topId: .paddingTop, bottomId: .paddingBottom, fallback: .length(.absolute(.px(0))))
            for child in children {
                guard let node = child as? NodeWithStyle else { continue }
                guard node.isAnonymous() else { continue }
                let childComputedValues = node.computedValues
                childComputedValues.inheritFrom(computedValues)
            }
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
