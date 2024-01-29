let HTML_NS = "http://www.w3.org/1999/xhtml"

// Fake namespace in Swift
enum DOM {
    typealias String = Swift.String

    static func printTree(node: DOM.Node, indent: String = "") {
        switch node {
        case let text as DOM.Text:
            print(indent + "\"" + text.data + "\"")
        case is DOM.DocumentType:
            print(indent + "#doctype")
        case is DOM.Document:
            print(indent + "#document")
            for node in node.childNodes {
                printTree(node: node, indent: indent + "  ")
            }
        default:
            let nodeName = node.nodeName?.lowercased() ?? "nil"
            var extra = ""
            if let element = node as? DOM.Element, element.attributes.length > 0 {
                for i in 0 ..< element.attributes.length {
                    if let attr = element.attributes.item(i) {
                        extra += " \(attr.name)=\(attr.value)"
                    }
                }
            }
            print(indent + "<\(nodeName)\(extra)>")
            for node in node.childNodes {
                printTree(node: node, indent: indent + "  ")
            }
        }
    }
}
