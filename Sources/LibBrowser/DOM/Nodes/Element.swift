extension DOM {
    // interface DOM.Element : Node {

    //   [CEReactions] attribute DOM.String className;
    //   [CEReactions, Unscopable] attribute DOM.String slot;

    //   boolean hasAttributes();
    //   [SameObject] readonly attribute NamedNodeMap attributes;
    //   DOM.String? getAttribute(DOM.String qualifiedName);
    //   DOM.String? getAttributeNS(DOM.String? namespace, DOM.String localName);
    //   [CEReactions] undefined setAttribute(DOM.String qualifiedName, DOM.String value);
    //   [CEReactions] undefined setAttributeNS(DOM.String? namespace, DOM.String qualifiedName, DOM.String value);
    //   [CEReactions] undefined removeAttribute(DOM.String qualifiedName);
    //   [CEReactions] undefined removeAttributeNS(DOM.String? namespace, DOM.String localName);
    //   [CEReactions] boolean toggleAttribute(DOM.String qualifiedName, optional boolean force);
    //   boolean hasAttribute(DOM.String qualifiedName);
    //   boolean hasAttributeNS(DOM.String? namespace, DOM.String localName);

    //   Attr? getAttributeNode(DOM.String qualifiedName);
    //   Attr? getAttributeNodeNS(DOM.String? namespace, DOM.String localName);
    //   [CEReactions] Attr? setAttributeNode(Attr attr);
    //   [CEReactions] Attr? setAttributeNodeNS(Attr attr);
    //   [CEReactions] Attr removeAttributeNode(Attr attr);

    //   ShadowRoot attachShadow(ShadowRootInit init);
    //   readonly attribute ShadowRoot? shadowRoot;

    //   DOM.Element? closest(DOM.String selectors);
    //   boolean matches(DOM.String selectors);
    //   boolean webkitMatchesSelector(DOM.String selectors); // legacy alias of .matches

    //   HTMLCollection getDOM.ElementsByTagName(DOM.String qualifiedName);
    //   HTMLCollection getDOM.ElementsByTagNameNS(DOM.String? namespace, DOM.String localName);
    //   HTMLCollection getDOM.ElementsByClassName(DOM.String classNames);

    //   [CEReactions] DOM.Element? insertAdjacentDOM.Element(DOM.String where, DOM.Element element); // legacy
    //   undefined insertAdjacentText(DOM.String where, DOM.String data); // legacy
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

    class Element: Node {
        // readonly attribute DOM.String? namespaceURI;
        var namespaceURI: DOM.String

        //  readonly attribute DOM.String? prefix;
        var prefix: DOM.String?

        // readonly attribute DOM.String localName;
        var localName: DOM.String

        // readonly attribute DOM.String tagName;
        var tagName: DOM.String {
            let name = localName.uppercased()
            return if prefix == nil {
                name
            } else {
                "\(prefix!):\(name)"
            }
        }

        var attributes: NamedNodeMap

        // [CEReactions] attribute DOM.String id;
        lazy var id: DOM.String = attributes.getNamedItem("id")?.value ?? ""

        // [SameObject, PutForwards=value] readonly attribute DOMTokenList classList;
        // The classList getter steps are to return a DOMTokenList object whose
        // associated element is this and whose associated attribute’s local
        // name is class. The token set of this particular DOMTokenList object
        // are also known as the element’s classes.
        var classList: DOM.TokenList {
            set {
                FIXME("DOM.Element.classList setter")
            }
            get {
                let attribute = attributes.getNamedItem("class") ?? DOM.Attr(name: "class", value: "")
                return DOM.TokenList(element: self, attribute: attribute)
            }
        }

        required init(localName: DOM.String,
                      attributes: [DOM.Attr] = [],
                      namespace: DOM.String,
                      prefix _: DOM.String? = nil,
                      parentNode: Node? = nil,
                      customElementState _: CustomElementState = .undefined,
                      customElementDefinition _: HTML.CustomElementDefinition? = nil,
                      isValue _: DOM.String? = nil,
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
        var qualifiedName: DOM.String {
            var qualifiedName = localName
            if let prefix {
                qualifiedName = "\(prefix):\(qualifiedName)"
            }
            return qualifiedName
        }

        // DOM.Element interface
        func hasAttribute(_ qualifiedName: DOM.String) -> Bool {
            attributes.getNamedItem(qualifiedName) != nil
        }

        func getAttribute(_ qualifiedName: DOM.String) -> DOM.String? {
            attributes.getNamedItem(qualifiedName)?.value
        }

        func setAttribute(_ qualifiedName: DOM.String, _ value: DOM.String) {
            attributes.setNamedItem(DOM.Attr(name: qualifiedName, value: value))
        }

        // sequence<DOM.String> getAttributeNames();
        func getAttributeNames() -> [DOM.String] {
            // The getAttributeNames() method steps are to return the qualified
            // names of the attributes in this’s attribute list, in order; otherwise
            // a new list.
            attributes.attributes.keys.map { $0 }
        }
    }
}

protocol StackOfOpenElementsNotification {
    func wasRemoved()
}
