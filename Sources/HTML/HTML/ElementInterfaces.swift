
extension HTML {
    static func elementInterface(localName: String, namespace _: String?) -> Element.Type {
        switch localName {
        case "body":
            return BodyElement.self
        case "div":
            return DivElement.self
        case "head":
            return HeadElement.self
        case "html":
            return HtmlElement.self
        case "script":
            return ScriptElement.self
        case "span":
            return SpanElement.self
        case "style":
            return StyleElement.self
        default:
            FIXME("Unknown element: \(localName)")
            return Element.self
        }
    }
}
