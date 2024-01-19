struct AdjustedInsertionLocation {
    var node: Node?
    var afterSibling: Node? = nil

    func insert(_ child: Node) {
        if let afterSibling = afterSibling {
            switch afterSibling {
                case let text as Text:
                    text.after(child)
                case let element as Element:
                    element.after(child)
                // case let documentType as DocumentType:
                //     documentType.after(child)
                default:
                    fatalError()
            }
        } else {
            node!.appendChild(child)
        }
    }
}
