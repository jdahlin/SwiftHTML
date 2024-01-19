// [Exposed=Window]
// interface Document : Node {
//   constructor();

//   [SameObject] readonly attribute DOMImplementation implementation;
//   readonly attribute USVString URL;
//   readonly attribute USVString documentURI;
//   readonly attribute DOMString compatMode;
//   readonly attribute DOMString characterSet;
//   readonly attribute DOMString charset; // legacy alias of .characterSet
//   readonly attribute DOMString inputEncoding; // legacy alias of .characterSet
//   readonly attribute DOMString contentType;

//   readonly attribute DocumentType? doctype;
//   readonly attribute Element? documentElement;
//   HTMLCollection getElementsByTagName(DOMString qualifiedName);
//   HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
//   HTMLCollection getElementsByClassName(DOMString classNames);

//   [CEReactions, NewObject] Element createElement(DOMString localName, optional (DOMString or ElementCreationOptions) options = {});
//   [CEReactions, NewObject] Element createElementNS(DOMString? namespace, DOMString qualifiedName, optional (DOMString or ElementCreationOptions) options = {});
//   [NewObject] DocumentFragment createDocumentFragment();
//   [NewObject] Text createTextNode(DOMString data);
//   [NewObject] CDATASection createCDATASection(DOMString data);
//   [NewObject] Comment createComment(DOMString data);
//   [NewObject] ProcessingInstruction createProcessingInstruction(DOMString target, DOMString data);

//   [CEReactions, NewObject] Node importNode(Node node, optional boolean deep = false);
//   [CEReactions] Node adoptNode(Node node);

//   [NewObject] Attr createAttribute(DOMString localName);
//   [NewObject] Attr createAttributeNS(DOMString? namespace, DOMString qualifiedName);

//   [NewObject] Event createEvent(DOMString interface); // legacy

//   [NewObject] Range createRange();

//   // NodeFilter.SHOW_ALL = 0xFFFFFFFF
//   [NewObject] NodeIterator createNodeIterator(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
//   [NewObject] TreeWalker createTreeWalker(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
// };

struct ElementCreationOptions {
    var is_: DOMString?
}

struct BrowsingContext {}

class Document: Node {
    var mode: DocumentMode = .noQuirks

    var browsingContext: BrowsingContext?

    // [CEReactions, NewObject] Element createElement(DOMString localName, optional (DOMString or ElementCreationOptions) options = {});
    func createElement(_ localName: DOMString,
                       options _: ElementCreationOptions? = nil) -> Element
    {
        return createElement(
            localName: localName,
            namespace: nil
        )
    }

    // https://dom.spec.whatwg.org/#concept-create-element
    func createElement(
        localName: DOMString,
        namespace _: DOMString?,
        prefix: DOMString? = nil,
        is _: DOMString? = nil,
        synchronousCustomElements _: Bool = false
    ) -> Element {
        // 1. If prefix was not given, let prefix be null.
        // 2. If is was not given, let is be null.

        // 3. Let result be null.
        var result: Element? = nil

        // 4. Let definition be the result of looking up a custom element
        //    definition given document, namespace, localName, and is.
        let definition: CustomElementDefinition? = nil

        // 5. If definition is non-null, and definition’s name is not equal to
        //    its local name (i.e., definition represents a customized built-in
        //    element), then:
        if definition != nil && definition!.name != localName {
            // 5.1 Let interface be the element interface for localName and the HTML namespace.

            // 5.2 Set result to a new element that implements interface, with no
            //     attributes, namespace set to the HTML namespace, namespace prefix
            //     set to prefix, local name set to localName, custom element state
            //     set to "undefined", custom element definition set to null, is
            //     value set to is, and node document set to document.

            // 5.3 If the synchronous custom elements flag is set, then run this
            //     step while catching any exceptions:

            // 5.3.1 Upgrade element using definition.

            // If this step threw an exception, then:

            // 5.3.1 Report the exception.

            // 5.3.2 Set result’s custom element state to "failed".

            // 5.4 Otherwise, enqueue a custom element upgrade reaction given result and definition.
        }

        // 6. Otherwise, if definition is non-null, then:

        // 6.1. If the synchronous custom elements flag is set, then run these steps while catching any exceptions:

        // 6.1.1. Let C be definition’s constructor.

        // 6.1.2. Set result to the result of constructing C, with no arguments.

        // 6.1.3. Assert: result’s custom element state and custom element definition are initialized.

        // 6.1.4. Assert: result’s namespace is the HTML namespace.

        // Note: IDL enforces that result is an HTMLElement object, which all use the HTML namespace.

        // 6.1.5. If result’s attribute list is not empty, then throw a "NotSupportedError" DOMException.

        // 6.1.6. If result has children, then throw a "NotSupportedError" DOMException.

        // 6.1.7. If result’s parent is not null, then throw a "NotSupportedError" DOMException.

        // 6.1.8. If result’s node document is not document, then throw a "NotSupportedError" DOMException.

        // 6.1.9. If result’s local name is not equal to localName, then throw a "NotSupportedError" DOMException.

        // 6.1.10. Set result’s namespace prefix to prefix.

        // 6.1.11 Set result’s is value to null.

        // If any of these steps threw an exception, then:

        // 1. Report the exception.

        // 2. Set result to a new element that implements the HTMLUnknownElement
        //    interface, with no attributes, namespace set to the HTML
        //    namespace, namespace prefix set to prefix, local name set to
        //    localName, custom element state set to "failed", custom element
        //    definition set to null, is value set to null, and node document
        //    set to document.

        // 6.2. Otherwise:

        // 6.2.1. Set result to a new element that implements the HTMLElement interface, with no attributes, namespace set to the HTML namespace, namespace prefix set to prefix, local name set to localName, custom element state set to "undefined", custom element definition set to null, is value set to null, and node document set to document.

        // 6.2.2. Enqueue a custom element upgrade reaction given result and definition.

        // 7. Otherwise:

        // 7.1 Let interface be the element interface for localName and namespace.

        let iface: Element.Type = Element.self

        // 7.1.2. Set result to a new element that implements interface, with no
        //        attributes, namespace set to namespace, namespace prefix set
        //        to prefix, local name set to localName, custom element state
        //        set to "uncustomized", custom element definition set to null,
        //        is value set to is, and node document set to document.
        result = iface.init(
            localName: localName,
            attributes: [],
            namespace: HTML_NS,
            prefix: prefix,
            customElementState: .undefined,
            customElementDefinition: nil,
            isValue: nil,
            nodeDocument: self
        )

        // 7.1.3. If namespace is the HTML namespace, and either localName is a
        //        valid custom element name or is is non-null, then set result’s
        //        custom element state to "undefined".

        // 8. Return result.
        return result!
    }

    // https://html.spec.whatwg.org/multipage/dom.html#the-body-element-2
    var body: Element? {
        // The body element of a Document object is its first element child whose
        // local name is body and whose namespace is the HTML namespace.
        for item in childNodes.array {
            if let element = item as? Element,
               element.localName == "body",
               element.namespaceURI == HTML_NS
            {
                return element
            }
        }
        return nil
    }
}
