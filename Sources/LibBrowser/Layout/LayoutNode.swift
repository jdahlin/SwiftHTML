extension Layout {
    class Node {
        let style: CSS.StyleProperties?
        let document: DOM.Document

        init(style: CSS.StyleProperties?, document: DOM.Document) {
            self.style = style
            self.document = document
        }

        var display: CSS.Display { style?.display.display() ?? CSS.Display(outer: .none) }
    }
}
