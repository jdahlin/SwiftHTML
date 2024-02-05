extension Layout {
    class Box: NodeWithStyleAndBoxModelMetrics {
        override init(document: DOM.Document, domNode: DOM.Node?, style: CSS.StyleProperties) {
            super.init(document: document, domNode: domNode, style: style)
        }

        override init(document: DOM.Document, domNode: DOM.Node?, computedValues: CSS.ComputedValues) {
            super.init(document: document, domNode: domNode, computedValues: computedValues)
        }
    }
}
