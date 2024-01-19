// https://dom.spec.whatwg.org/#namednodemap
// [Exposed=Window,
//  LegacyUnenumerableNamedProperties]
// interface NamedNodeMap {
// };

class NamedNodeMap {
    var attributes: [DOMString: DOMString] = [:]
    public var ownerElement: Element?

    // readonly attribute unsigned long length;
    var length: UInt { UInt(attributes.count) }

    init(attributes: [Attr], ownerElement: Element? = nil) {
        self.attributes = attributes.reduce(into: [:]) { $0[$1.name] = $1.value }
        self.ownerElement = ownerElement
    }

    // getter Attr? item(unsigned long index);
    func item(_ index: UInt) -> Attr? {
        guard index < length else { return nil }
        let key = Array(attributes.keys)[Int(index)]
        return Attr(name: key, value: attributes[key] ?? "")
    }

    // getter Attr? getNamedItem(DOMString qualifiedName);
    func getNamedItem(_ qualifiedName: DOMString) -> Attr? {
        guard let value = attributes[qualifiedName] else { return nil }
        return Attr(name: qualifiedName, value: value)
    }

    // [CEReactions] Attr? setNamedItem(Attr attr);
    @discardableResult
    func setNamedItem(_ attr: Attr) -> Attr? {
        attributes[attr.name] = attr.value
        return attr
    }

    // [CEReactions] Attr removeNamedItem(DOMString qualifiedName);
    func removeNamedItem(_ qualifiedName: DOMString) -> Attr? {
        guard let value = attributes[qualifiedName] else { return nil }
        attributes[qualifiedName] = nil
        return Attr(name: qualifiedName, value: value)
    }

    // Attr? getNamedItemNS(DOMString? namespace, DOMString localName);
    // [CEReactions] Attr? setNamedItemNS(Attr attr);
    // [CEReactions] Attr removeNamedItemNS(DOMString? namespace, DOMString localName);
}
