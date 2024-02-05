extension Layout {
    class ViewPort: BlockContainer {
        init(document: DOM.Document, style: CSS.StyleProperties) {
            super.init(document: document, domNode: document, style: style)
        }
    }
}
