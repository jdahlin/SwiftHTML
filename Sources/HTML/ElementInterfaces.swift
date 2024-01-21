
func elementInterface(localName: String, namespace _: String?) -> Element.Type {
    switch localName {
    case "body":
        return HTMLBodyElement.self
    case "div":
        return HTMLDivElement.self
    case "head":
        return HTMLHeadElement.self
    case "html":
        return HTMLHtmlElement.self
    case "script":
        return HTMLScriptElement.self
    case "style":
        return HTMLStyleElement.self
    default:
        FIXME("Unknown element: \(localName)")
        return HTMLElement.self
    }
}
