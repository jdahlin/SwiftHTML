import CoreText

extension Layout {
    class Node {
        let document: DOM.Document
        let domNode: DOM.Node?
        var children: [Node] = []
        var childrenAreInline = false
        var hasStyle: Bool = false
        var parent: Node?

        init(document: DOM.Document, domNode: DOM.Node?) {
            self.document = document
            self.domNode = domNode
        }

        func appendChild(_ child: Node) {
            children.append(child)
            child.parent = self
        }

        func prependChild(_ child: Node) {
            children.insert(child, at: 0)
            child.parent = self
        }

        func isAnonymous() -> Bool {
            domNode == nil
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

        static func nearestAncestorCapableOfFormingAContainingBlock(node: Node) -> Box? {
            var current = node
            while let parent = current.parent {
                if parent is BlockContainer {
                    return parent as? Box
                }
                current = parent
            }
            return nil
        }

        func containingBlock() -> Box? {
            if self is TextNode {
                return Node.nearestAncestorCapableOfFormingAContainingBlock(node: self)
            }

            // FIXME: Absolute position
            // FIXME: Fixed position
            return Node.nearestAncestorCapableOfFormingAContainingBlock(node: self)
        }

        func hasStyleOrParentWithStyle() -> Bool {
            if hasStyle {
                return true
            }
            if let parent {
                return parent.hasStyleOrParentWithStyle()
            }
            return false
        }

        func computedValues() -> CSS.ComputedValues {
            assert(hasStyleOrParentWithStyle())
            if hasStyle, let nodeWithStyle = self as? NodeWithStyle {
                return nodeWithStyle.computedValues
            }
            return parent!.computedValues()
        }

        func fontMeasurements() -> FontMeasurements {
            guard let nodeWithStyle = self as? NodeWithStyle else {
                DIE("not a style node")
            }
            guard let rootElement = document.documentElement else {
                DIE("no document element")
            }
            let ctFont = CTFontCreateUIFontForLanguage(.system, 12, nil)!
            let fontMeasurements = FontMeasurements(
                viewportRect: document.navigable!.viewportRect(),
                fontMetrics: FontMetrics(fontSize: computedValues().fontSize,
                                         pixelMetrics: nodeWithStyle.firstAvailableFont().pixelMetrics()),
                rootFontMetrics: FontMetrics(fontSize: CSS.Pixels(16), pixelMetrics: ctFont.pixelMetrics())
            )
            return fontMeasurements
        }

        func isRootElement() -> Bool {
            if isAnonymous() {
                return false
            }
            return domNode is HTML.HtmlElement
        }
    }
}
