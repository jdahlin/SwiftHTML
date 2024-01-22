extension Node: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Node: Equatable {
    // https://dom.spec.whatwg.org/#concept-node-equals
    public static func == (a: Node, b: Node) -> Bool {
        // A node A equals a node B if all of the following conditions are true:

        // A and B implement the same interfaces.
        guard type(of: a) == type(of: b) else {
            return false
        }

        // The following are equal, switching on the interface A implements:
        switch (a, b) {
        // DocumentType
        case let (a, b) as (DocumentType, DocumentType):
            // Its name, public ID, and system ID.
            return a.name == b.name && a.publicId == b.publicId && a.systemId == b.systemId

        // Element
        case let (a, b) as (Element, Element):
            // Its namespace, namespace prefix, local name, and its attribute list’s size.
            return a.namespaceURI == b.namespaceURI
                && /* a.prefix == b.prefix && a.localName == b.localName && */ a.attributes.length
                == b.attributes.length

        // Attr
        case let (a, b) as (Attr, Attr):
            // Its namespace, namespace prefix, local name, and value.
            return a.namespaceURI == b.namespaceURI
                && /* a.prefix == b.prefix && a.localName == b.localName && */ a.value == b.value

        // ProcessingInstruction
        case let (a, b) as (ProcessingInstruction, ProcessingInstruction):
            // Its target and data.
            return a.target == b.target && a.data == b.data

        // Text
        case let (a, b) as (Text, Text):
            // Its data.
            return a.data == b.data

        // Comment
        case let (a, b) as (Comment, Comment):
            // Its data.
            return a.data == b.data

        // Otherwise
        default:
            // —
            return false
        }
    }
}
