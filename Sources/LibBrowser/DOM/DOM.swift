let HTML_NS = "http://www.w3.org/1999/xhtml"

// Fake namespace in Swift
enum DOM {
    typealias String = Swift.String

    static func printTree(_ node: DOM.Node, _ indent: String = "") {
        for child in node.childNodes {
            switch child {
            case is DOM.Text:
                let text = child as! DOM.Text
                print(indent + text.data.debugDescription)
            default:
                let nodeName = child.nodeName?.lowercased() ?? "nil"
                var extra = ""
                if let element = child as? DOM.Element, element.attributes.length > 0 {
                    for i in 0 ..< element.attributes.length {
                        if let attr = element.attributes.item(i) {
                            extra += " \(attr.name)=\"\(attr.value)\""
                        }
                    }
                }
                print(indent + "<\(nodeName)\(extra)>")
                printTree(child, indent + "  ")
                print(indent + "</\(nodeName)>")
            }
        }
    }
}
