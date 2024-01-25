extension DOM {
    // 4.9.2 https://dom.spec.whatwg.org/#interface-attr
    // [Exposed=Window]

    class Attr: Node {
        // The namespaceURI getter steps are to return this’s namespace.
        // readonly attribute DOM.String? namespaceURI;
        public let namespaceURI: DOM.String?

        // The prefix getter steps are to return this’s namespace prefix.
        // readonly attribute DOM.String? prefix
        public let prefix: DOM.String?

        // The localName getter steps are to return this’s local name.
        // readonly attribute DOM.String localName;
        public let localName: DOM.String

        // The name getter steps are to return this’s qualified name.
        // readonly attribute DOM.String name
        public let name: DOM.String

        // The value getter steps are to return this’s value.
        // [CEReactions] attribute DOM.String value;
        public let value: DOM.String

        // The ownerElement attribute’s getter must return this’s element.
        // readonly attribute DOM.Element? ownerElement;
        public let ownerElement: DOM.Element?

        // readonly attribute boolean specified; // useless; always returns true
        public let specified: Bool = true

        init(
            name: DOM.String,
            value: DOM.String,
            ownerElement: DOM.Element? = nil,
            namespaceURI: DOM.String? = nil,
            prefix: DOM.String? = nil
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
        var qualifiedName: DOM.String {
            // An attribute’s qualified name is its local name if its namespace prefix
            // is null, and its namespace prefix, followed by ":", followed by its local
            // name, otherwise.
            var qualifiedName = localName
            if let prefix {
                qualifiedName = "\(prefix):\(qualifiedName)"
            }
            return qualifiedName
        }
    }
}
