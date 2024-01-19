// interface Element : Node {

//   [CEReactions] attribute DOMString id;
//   [CEReactions] attribute DOMString className;
//   [SameObject, PutForwards=value] readonly attribute DOMTokenList classList;
//   [CEReactions, Unscopable] attribute DOMString slot;

//   boolean hasAttributes();
//   [SameObject] readonly attribute NamedNodeMap attributes;
//   sequence<DOMString> getAttributeNames();
//   DOMString? getAttribute(DOMString qualifiedName);
//   DOMString? getAttributeNS(DOMString? namespace, DOMString localName);
//   [CEReactions] undefined setAttribute(DOMString qualifiedName, DOMString value);
//   [CEReactions] undefined setAttributeNS(DOMString? namespace, DOMString qualifiedName, DOMString value);
//   [CEReactions] undefined removeAttribute(DOMString qualifiedName);
//   [CEReactions] undefined removeAttributeNS(DOMString? namespace, DOMString localName);
//   [CEReactions] boolean toggleAttribute(DOMString qualifiedName, optional boolean force);
//   boolean hasAttribute(DOMString qualifiedName);
//   boolean hasAttributeNS(DOMString? namespace, DOMString localName);

//   Attr? getAttributeNode(DOMString qualifiedName);
//   Attr? getAttributeNodeNS(DOMString? namespace, DOMString localName);
//   [CEReactions] Attr? setAttributeNode(Attr attr);
//   [CEReactions] Attr? setAttributeNodeNS(Attr attr);
//   [CEReactions] Attr removeAttributeNode(Attr attr);

//   ShadowRoot attachShadow(ShadowRootInit init);
//   readonly attribute ShadowRoot? shadowRoot;

//   Element? closest(DOMString selectors);
//   boolean matches(DOMString selectors);
//   boolean webkitMatchesSelector(DOMString selectors); // legacy alias of .matches

//   HTMLCollection getElementsByTagName(DOMString qualifiedName);
//   HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
//   HTMLCollection getElementsByClassName(DOMString classNames);

//   [CEReactions] Element? insertAdjacentElement(DOMString where, Element element); // legacy
//   undefined insertAdjacentText(DOMString where, DOMString data); // legacy
// };

// dictionary ShadowRootInit {
//   required ShadowRootMode mode;
//   boolean delegatesFocus = false;
//   SlotAssignmentMode slotAssignment = "named";
//   boolean clonable = false;
// };

// https://dom.spec.whatwg.org/#concept-element-custom-element-state
enum CustomElementState {
    case undefined
    case failed
    case uncustomized
    case customized
    case precustomized
    case custom
}

public class Element: Node {
    // readonly attribute DOMString? namespaceURI;
    var namespaceURI: DOMString

    //  readonly attribute DOMString? prefix;
    var prefix: DOMString?

    // readonly attribute DOMString localName;
    var localName: DOMString

    // readonly attribute DOMString tagName;
    var tagName: DOMString {
        let name = localName.uppercased()
        return if prefix == nil {
            name
        } else {
            "\(prefix!):\(name)"
        }
    }

    var attributes: NamedNodeMap

    required init(localName: DOMString,
                  attributes: [Attr] = [],
                  namespace: DOMString,
                  prefix _: DOMString? = nil,
                  parentNode: Node? = nil,
                  customElementState _: CustomElementState = .undefined,
                  customElementDefinition _: CustomElementDefinition? = nil,
                  isValue _: DOMString? = nil,
                  nodeDocument: Document)
    {
        self.attributes = NamedNodeMap(attributes: attributes)
        namespaceURI = namespace
        self.localName = localName
        super.init(ownerDocument: nodeDocument, parentNode: parentNode)
        self.attributes.ownerElement = self
    }

    // An element’s qualified name is its local name if its namespace prefix is
    // null; otherwise its namespace prefix, followed by ":", followed by its
    // local name.
    var qualifiedName: DOMString {
        var qualifiedName = localName
        if let prefix = prefix {
            qualifiedName = "\(prefix):\(qualifiedName)"
        }
        return qualifiedName
    }

    // Element interface
    func hasAttribute(_ qualifiedName: DOMString) -> Bool {
        return attributes.getNamedItem(qualifiedName) != nil
    }

    func getAttribute(_ qualifiedName: DOMString) -> DOMString? {
        return attributes.getNamedItem(qualifiedName)?.value
    }

    func setAttribute(_ qualifiedName: DOMString, _ value: DOMString) {
        attributes.setNamedItem(Attr(name: qualifiedName, value: value))
    }
}
