extension Layout {
    class ViewPort: BlockContainer {
        init(document: DOM.Document, computedStyle: CSS.StyleProperties) {
            super.init(document: document, domNode: document, computedStyle: computedStyle)
        }

        override func createPaintable() -> Painting.Paintable? {
            Painting.ViewPortPaintable(layoutNode: self)
        }
    }
}
