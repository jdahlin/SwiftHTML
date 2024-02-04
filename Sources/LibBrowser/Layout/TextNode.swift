extension Layout {
    class TextNode: Node {
        var domNode: DOM.Text
        init(document: DOM.Document, domNode: DOM.Text) {
            self.domNode = domNode
            super.init(style: nil, document: document)
        }
    }
}
