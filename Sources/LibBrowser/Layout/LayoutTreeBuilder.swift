extension Layout {
    class Context {}

    enum AppendOrPrepend {
        case append
        case prepend
    }

    class TreeBuilder {
        var layoutRoot: Layout.Node!

        func build(domNode: DOM.Document) -> Layout.ViewPort {
            createLayoutTree(domNode: domNode)
            return layoutRoot as! Layout.ViewPort
        }

        func createLayoutTree(domNode: DOM.Node) {
            let document = domNode.ownerDocument!
            var styleComputer = document.styleComputer
            var style: CSS.StyleProperties
            var display = CSS.Display(outer: .none)
            var layoutNode: Layout.Node?
            if let element = domNode as? DOM.Element {
                style = element.computedCSSValues!
                display = style.display.display()
                if display.isNone() {
                    return
                }
                layoutNode = element.createLayoutNode(style: style)
            } else if let document = domNode as? DOM.Document {
                style = styleComputer.createDocumentStyle()
                display = style.display.display()
                layoutNode = Layout.ViewPort(style: style, document: document)
            } else if let textNode = domNode as? DOM.Text {
                layoutNode = Layout.TextNode(document: domNode.ownerDocument!, domNode: textNode)
                display = CSS.Display(outer: .inline, inner: .flow)
            }

            guard let layoutNode else {
                return
            }

            if domNode.parentOrShadowHost() == nil {
                layoutRoot = layoutNode
            } else {
                insertNodeIntoInlineOrBlockAncestor(
                    layoutNode: layoutNode,
                    display: display,
                    appendOrPrepend: .append
                )
            }
            for child in domNode.childNodes {
                createLayoutTree(domNode: child)
            }
        }

        func insertNodeIntoInlineOrBlockAncestor(
            layoutNode: Layout.Node,
            display _: CSS.Display,
            appendOrPrepend _: Layout.AppendOrPrepend
        ) {
            guard layoutNode.display.isContents() else { return }

            if case .inline = layoutNode.display.outer {}
        }
    }
}

extension DOM.Element {
    func createLayoutNode(style: CSS.StyleProperties) -> Layout.Node {
        let display = style.display.display()
        return createLayoutNodeFromDisplay(
            style: style,
            document: ownerDocument!,
            display: display
        )
    }

    func createLayoutNodeFromDisplay(style: CSS.StyleProperties,
                                     document: DOM.Document,
                                     display: CSS.Display) -> Layout.Node
    {
        switch (display.inner, display.outer) {
        case (.flowRoot, .inline):
            return Layout.BlockContainer(style: style, document: document)
        case (.flow, .inline):
            return Layout.InlineNode(style: style, document: document)
        case (_, .inline):
            break
        case (.flow, _), (.flowRoot, _):
            return Layout.BlockContainer(style: style, document: document)
        case _ where display.isContents():
            return Layout.BlockContainer(style: style, document: document)
        default:
            break
        }
        FIXME("display \(display) not implemented")
        return Layout.InlineNode(style: style, document: document)
    }
}
