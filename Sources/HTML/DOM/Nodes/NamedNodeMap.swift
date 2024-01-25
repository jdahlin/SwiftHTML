extension DOM {
    // https://dom.spec.whatwg.org/#namednodemap
    // [Exposed=Window,
    //  LegacyUnenumerableNamedProperties]
    // interface NamedNodeMap {
    // };

    class NamedNodeMap {
        var attributes: [DOM.String: DOM.String] = [:]
        public var ownerElement: DOM.Element?

        // readonly attribute unsigned long length;
        var length: UInt { UInt(attributes.count) }

        init(attributes: [DOM.Attr], ownerElement: DOM.Element? = nil) {
            self.attributes = attributes.reduce(into: [:]) { $0[$1.name] = $1.value }
            self.ownerElement = ownerElement
        }

        // getter Attr? item(unsigned long index);
        func item(_ index: UInt) -> DOM.Attr? {
            guard index < length else { return nil }
            let key = Array(attributes.keys)[Int(index)]
            return DOM.Attr(name: key, value: attributes[key] ?? "")
        }

        // getter Attr? getNamedItem(DOM.String qualifiedName);
        func getNamedItem(_ qualifiedName: DOM.String) -> DOM.Attr? {
            guard let value = attributes[qualifiedName] else { return nil }
            return DOM.Attr(name: qualifiedName, value: value)
        }

        // [CEReactions] Attr? setNamedItem(Attr attr);
        @discardableResult
        func setNamedItem(_ attr: DOM.Attr) -> DOM.Attr? {
            attributes[attr.name] = attr.value
            return attr
        }

        // [CEReactions] Attr removeNamedItem(DOM.String qualifiedName);
        func removeNamedItem(_ qualifiedName: DOM.String) -> DOM.Attr? {
            guard let value = attributes[qualifiedName] else { return nil }
            attributes[qualifiedName] = nil
            return DOM.Attr(name: qualifiedName, value: value)
        }

        // Attr? getNamedItemNS(DOM.String? namespace, DOM.String localName);
        // [CEReactions] Attr? setNamedItemNS(Attr attr);
        // [CEReactions] Attr removeNamedItemNS(DOM.String? namespace, DOM.String localName);
    }
}
