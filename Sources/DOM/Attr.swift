// 4.9.2 https://dom.spec.whatwg.org/#interface-attr
// [Exposed=Window]

public class Attr: Node {
    // The namespaceURI getter steps are to return this’s namespace.
    // readonly attribute DOMString? namespaceURI;
    public let namespaceURI: DOMString?

    // The prefix getter steps are to return this’s namespace prefix.
    // readonly attribute DOMString? prefix
    public let prefix: DOMString?

    // The localName getter steps are to return this’s local name.
    // readonly attribute DOMString localName;
    public let localName: DOMString

    // The name getter steps are to return this’s qualified name.
    // readonly attribute DOMString name
    public let name: DOMString

    // The value getter steps are to return this’s value.
    // [CEReactions] attribute DOMString value;
    public let value: DOMString

    // The ownerElement attribute’s getter must return this’s element.
    // readonly attribute Element? ownerElement;
    public let ownerElement: Element?

    // readonly attribute boolean specified; // useless; always returns true
    public let specified: Bool = true

    init(
        name: DOMString,
        value: DOMString,
        ownerElement: Element? = nil,
        namespaceURI: DOMString? = nil,
        prefix: DOMString? = nil
    ) {
        self.name = name
        self.value = value
        localName = name
        self.ownerElement = ownerElement
        self.namespaceURI = namespaceURI
        self.prefix = prefix
        super.init()
    }

    // https://dom.spec.whatwg.org/#concept-attribute-qualified-name
    var qualifiedName: DOMString {
        // An attribute’s qualified name is its local name if its namespace prefix
        // is null, and its namespace prefix, followed by ":", followed by its local
        // name, otherwise.
        var qualifiedName = localName
        if let prefix = prefix {
            qualifiedName = "\(prefix):\(qualifiedName)"
        }
        return qualifiedName
    }
}
