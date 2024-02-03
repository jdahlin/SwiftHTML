extension Layout {
    class Context {}

    class TreeBuilder {
        var layoutRoot: Layout.ViewPort!

        func build(domNode: DOM.Document) -> Layout.ViewPort {
            createLayoutTree(domNode: domNode)
            return layoutRoot
        }

        func createLayoutTree(domNode: DOM.Node) {
            // let document = domNode.ownerDocument!
            // let styleComputer = document.styleComputer
            let style: CSS.StyleProperties
            let display: CSS.Display
            if let element = domNode as? DOM.Element {
                style = element.computedCSSValues!
                display = style.display.display()
                if display.isNoneOrContents() {
                    return
                }
            }
        }
    }
}
