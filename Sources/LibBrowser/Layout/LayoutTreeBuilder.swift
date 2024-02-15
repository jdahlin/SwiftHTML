extension Layout {
    class Context {}

    enum AppendOrPrepend {
        case append
        case prepend
    }

    class TreeBuilder {
        var layoutRoot: Layout.Node!
        var ancestorStack: [Layout.NodeWithStyle] = []

        func pushParent(layoutNode: Layout.NodeWithStyle) {
            ancestorStack.append(layoutNode)
        }

        func popParent() {
            ancestorStack.removeLast()
        }

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
                if style.display!.isNone() {
                    return
                }
                layoutNode = element.createLayoutNode(style: style)
            } else if let document = domNode as? DOM.Document {
                style = styleComputer.createDocumentStyle()
                display = style.display!
                layoutNode = Layout.ViewPort(document: document, style: style)
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

            if domNode.childNodes.length > 0 {
                pushParent(layoutNode: layoutNode as! Layout.NodeWithStyle)

                for child in domNode.childNodes {
                    createLayoutTree(domNode: child)
                }
                popParent()
            }
        }

        func insertNodeIntoInlineOrBlockAncestor(
            layoutNode: Layout.Node,
            display _: CSS.Display,
            appendOrPrepend: Layout.AppendOrPrepend
        ) {
            guard !layoutNode.display.isContents() else { return }

            if case .inline = layoutNode.display.outer {
                let nearestAncestorWithoutDisplayContents
                    = ancestorStack.reversed().filter { !$0.display.isContents() }.first!
                let insertionPoint = insertionPointForInlineNode(layoutParent: nearestAncestorWithoutDisplayContents)

                switch appendOrPrepend {
                case .append:
                    insertionPoint.appendChild(layoutNode)
                case .prepend:
                    insertionPoint.prependChild(layoutNode)
                }
                insertionPoint.childrenAreInline = true
            } else {
                let nearestNonInlineAnestor = ancestorStack.reversed().filter {
                    let display = $0.display
                    switch (display.outer, display.inner) {
                    case (.contents, _):
                        return false
                    case _ where display.outer != .inline:
                        return true
                    default:
                        return false
                    }
                }.first!
                let insertionPoint = insertionPointForInlineNode(layoutParent: nearestNonInlineAnestor)
                switch appendOrPrepend {
                case .append:
                    insertionPoint.appendChild(layoutNode)
                case .prepend:
                    insertionPoint.prependChild(layoutNode)
                }

                insertionPoint.childrenAreInline = false
            }
        }

        func insertionPointForInlineNode(layoutParent: Layout.NodeWithStyle) -> Layout.Node {
            func lastChildCreatingAnonymousWrapperIfNeeded() -> Layout.Node {
                func shouldAppend() -> Bool {
                    guard let lastChild else {
                        return true
                    }
                    if lastChild.isAnonymous() {
                        return true
                    }
                    if !lastChild.childrenAreInline {
                        return true
                    }
                    if lastChild.isGenerated() {
                        return true
                    }
                    return false
                }
                let lastChild = layoutParent.children.last
                if shouldAppend() {
                    layoutParent.appendChild(layoutParent.createAnonymousWrapper())
                }
                return layoutParent.children.last!
            }

            let display = layoutParent.display
            if display.isInlineOutside() && display.isFlowInside() {
                return layoutParent
            }

            if layoutParent.hasInFlowBlockChildren() || layoutParent.childrenAreInline {
                return layoutParent
            }

            return lastChildCreatingAnonymousWrapperIfNeeded()
        }
    }
}

extension DOM.Element {
    func createLayoutNode(style: CSS.StyleProperties) -> Layout.Node {
        let display = style.display!
        return createLayoutNodeFromDisplay(
            style: style,
            document: ownerDocument!,
            display: display,
            element: self
        )
    }

    func createLayoutNodeFromDisplay(style: CSS.StyleProperties,
                                     document: DOM.Document,
                                     display: CSS.Display,
                                     element: DOM.Element) -> Layout.Node
    {
        switch (display.inner, display.outer) {
        case (.flowRoot, .inline):
            return Layout.BlockContainer(document: document, domNode: element, style: style)
        case (.flow, .inline):
            return Layout.InlineNode(document: document, domNode: element, style: style)
        case (_, .inline):
            break
        case (.flow, _), (.flowRoot, _):
            return Layout.BlockContainer(document: document, domNode: element, style: style)
        case _ where display.isContents():
            return Layout.BlockContainer(document: document, domNode: element, style: style)
        default:
            break
        }
        FIXME("display \(display) not implemented")
        return Layout.InlineNode(document: document, domNode: element, style: style)
    }
}
