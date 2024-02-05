extension DOM {
    // [Exposed=Window]
    // interface Document : Node {
    //   constructor();

    //   [SameObject] readonly attribute DOMImplementation implementation;
    //   readonly attribute USVString URL;
    //   readonly attribute USVString documentURI;
    //   readonly attribute DOM.String compatMode;
    //   readonly attribute DOM.String characterSet;
    //   readonly attribute DOM.String charset; // legacy alias of .characterSet
    //   readonly attribute DOM.String inputEncoding; // legacy alias of .characterSet
    //   readonly attribute DOM.String contentType;

    //   readonly attribute DocumentType? doctype;
    //   readonly attribute DOM.Element? documentDOM.Element;
    //   HTMLCollection getDOM.ElementsByTagName(DOM.String qualifiedName);
    //   HTMLCollection getDOM.ElementsByTagNameNS(DOM.String? namespace, DOM.String localName);
    //   HTMLCollection getDOM.ElementsByClassName(DOM.String classNames);

    //   [CEReactions, NewObject] DOM.Element createDOM.Element(DOM.String localName, optional (DOM.String or DOM.ElementCreationOptions) options = {});
    //   [CEReactions, NewObject] DOM.Element createDOM.ElementNS(DOM.String? namespace, DOM.String qualifiedName, optional (DOM.String or DOM.ElementCreationOptions) options = {});
    //   [NewObject] DocumentFragment createDocumentFragment();
    //   [NewObject] Text createTextNode(DOM.String data);
    //   [NewObject] CDATASection createCDATASection(DOM.String data);
    //   [NewObject] Comment createComment(DOM.String data);
    //   [NewObject] ProcessingInstruction createProcessingInstruction(DOM.String target, DOM.String data);

    //   [CEReactions, NewObject] Node importNode(Node node, optional boolean deep = false);
    //   [CEReactions] Node adoptNode(Node node);

    //   [NewObject] Attr createAttribute(DOM.String localName);
    //   [NewObject] Attr createAttributeNS(DOM.String? namespace, DOM.String qualifiedName);

    //   [NewObject] Event createEvent(DOM.String interface); // legacy

    //   [NewObject] Range createRange();

    //   NodeFilter.SHOW_ALL = 0xFFFFFFFF
    //   [NewObject] NodeIterator createNodeIterator(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
    //   [NewObject] TreeWalker createTreeWalker(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);

    // };

    // From HTML Spec
    // enum DocumentReadyState { "loading", "interactive", "complete" };
    // enum DocumentVisibilityState { "visible", "hidden" };
    // typedef (HTMLScriptElement or SVGScriptDOM.Element) HTMLOrSVGScriptDOM.Element;

    // [LegacyOverrideBuiltIns]
    // partial interface Document {
    //   static Document parseHTMLUnsafe(DOM.String html);

    //   // resource metadata management
    //   [PutForwards=href, LegacyUnforgeable] readonly attribute Location? location;
    //   attribute USVString domain;
    //   readonly attribute USVString referrer;
    //   attribute USVString cookie;
    //   readonly attribute DOM.String lastModified;
    //   readonly attribute DocumentReadyState readyState;

    //   // DOM tree accessors
    //   getter object (DOM.String name);
    //   [CEReactions] attribute DOM.String title;
    //   [CEReactions] attribute DOM.String dir;
    //   [CEReactions] attribute HTMLElement? body;
    //   readonly attribute HTMLHeadElement? head;
    //   [SameObject] readonly attribute HTMLCollection images;
    //   [SameObject] readonly attribute HTMLCollection embeds;
    //   [SameObject] readonly attribute HTMLCollection plugins;
    //   [SameObject] readonly attribute HTMLCollection links;
    //   [SameObject] readonly attribute HTMLCollection forms;
    //   [SameObject] readonly attribute HTMLCollection scripts;
    //   NodeList getDOM.ElementsByName(DOM.String elementName);
    //   readonly attribute HTMLOrSVGScriptDOM.Element? currentScript; // classic scripts in a document tree only

    //   // dynamic markup insertion
    //   [CEReactions] Document open(optional DOM.String unused1, optional DOM.String unused2); // both arguments are ignored
    //   WindowProxy? open(USVString url, DOM.String name, DOM.String features);
    //   [CEReactions] undefined close();
    //   [CEReactions] undefined write(DOM.String... text);
    //   [CEReactions] undefined writeln(DOM.String... text);

    //   // user interaction
    //   readonly attribute WindowProxy? defaultView;
    //   boolean hasFocus();
    //   [CEReactions] attribute DOM.String designMode;
    //   [CEReactions] boolean execCommand(DOM.String commandId, optional boolean showUI = false, optional DOM.String value = "");
    //   boolean queryCommandEnabled(DOM.String commandId);
    //   boolean queryCommandIndeterm(DOM.String commandId);
    //   boolean queryCommandState(DOM.String commandId);
    //   boolean queryCommandSupported(DOM.String commandId);
    //   DOM.String queryCommandValue(DOM.String commandId);
    //   readonly attribute boolean hidden;
    //   readonly attribute DocumentVisibilityState visibilityState;

    //   // special event handler IDL attributes that only apply to Document objects
    //   [LegacyLenientThis] attribute EventHandler onreadystatechange;
    //   attribute EventHandler onvisibilitychange;

    //   // also has obsolete members
    // };
    // Document includes GlobalEventHandlers;

    struct ElementCreationOptions {
        var is_: DOM.String?
    }

    struct BrowsingContext {}

    class Document: Node {
        var mode: HTML.DocumentMode = .noQuirks

        var browsingContext: BrowsingContext?

        // https://drafts.csswg.org/cssom/#dom-documentorshadowroot-stylesheets
        // [SameObject] readonly attribute StyleSheetList styleSheets;
        var styleSheets: CSSOM.StyleSheetList {
            CSSOM.StyleSheetList(styleSheets: rootStyleSheets)
        }

        var styleComputer: CSS.StyleComputer = .init()

        var rootStyleSheets: [CSSOM.CSSStyleSheet] = []

        var navigable: Navigable? = .init()

        var layoutRoot: Layout.ViewPort?

        init() {
            super.init()
            // A document’s node document is itself.
            ownerDocument = self
        }

        // [CEReactions, NewObject] DOM.Element createDOM.Element(DOM.String localName, optional (DOM.String or DOM.ElementCreationOptions) options = {});
        func createElement(_ localName: DOM.String,
                           options _: DOM.ElementCreationOptions? = nil) -> DOM.Element
        {
            createElement(
                localName: localName,
                namespace: nil
            )
        }

        // https://dom.spec.whatwg.org/#concept-create-element
        func createElement(
            localName: DOM.String,
            namespace: DOM.String?,
            prefix: DOM.String? = nil,
            is _: DOM.String? = nil,
            synchronousCustomElements _: Bool = false
        ) -> DOM.Element {
            // 1. If prefix was not given, let prefix be null.
            // 2. If is was not given, let is be null.

            // 3. Let result be null.
            var result: DOM.Element? = nil

            // 4. Let definition be the result of looking up a custom element
            //    definition given document, namespace, localName, and is.
            let definition: HTML.CustomElementDefinition? = nil

            // 5. If definition is non-null, and definition’s name is not equal to
            //    its local name (i.e., definition represents a customized built-in
            //    element), then:
            if definition != nil, definition!.name != localName {
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
            } else if definition != nil {
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

                // 2. Set result to a new element that implements the HTMLUnknownDOM.Element
                //    interface, with no attributes, namespace set to the HTML
                //    namespace, namespace prefix set to prefix, local name set to
                //    localName, custom element state set to "failed", custom element
                //    definition set to null, is value set to null, and node document
                //    set to document.
                // 6.2. Otherwise:

                // 6.2.1. Set result to a new element that implements the HTMLElement
                // interface, with no attributes, namespace set to the HTML namespace,
                // namespace prefix set to prefix, local name set to localName, custom
                // element state set to "undefined", custom element definition set to
                // null, is value set to null, and node document set to document.

                // 6.2.2. Enqueue a custom element upgrade reaction given result and definition.
            } else {
                // 7. Otherwise:

                // 7.1 Let interface be the element interface for localName and namespace.
                let iface: DOM.Element.Type = HTML.elementInterface(localName: localName, namespace: namespace)

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
            }

            // 8. Return result.
            return result!
        }

        // https://dom.spec.whatwg.org/#document-element
        var documentElement: DOM.Element? {
            // The document element of a document is its first element child.
            for item in childNodes {
                if let element = item as? DOM.Element {
                    return element
                }
            }
            return nil
        }

        // https://html.spec.whatwg.org/multipage/dom.html#the-body-element-2
        var body: DOM.Element? {
            // The body element of a document is the first of the html element's
            // children that is either a body element or a frameset element, or null
            // if there is no such element.
            guard let documentElement else {
                return nil
            }
            for item in documentElement.childNodes {
                guard let element = item as? DOM.Element,
                      element.localName == "body", element.namespaceURI == HTML_NS
                else {
                    continue
                }
                return element
            }
            return nil
        }

        // https://dom.spec.whatwg.org/#concept-node-adopt
        // https://dom.spec.whatwg.org/#dom-document-adoptnode
        func adoptNode(node: Node) -> Node {
            // 1. Let oldDocument be node’s node document.
            let oldDocument = node.ownerDocument

            // 2. If node’s parent is non-null, then remove node.
            if node.parentNode != nil {
                removeNode(node: node)
            }

            // 3. If document is not oldDocument, then:
            if self != oldDocument {
                // 3.1. For each inclusiveDescendant in node’s shadow-including
                // inclusive descendants:

                // 3.1.1. Set inclusiveDescendant’s node document to document.

                // 3.1.2. If inclusiveDescendant is an element, then set the node
                // document of each attribute in inclusiveDescendant’s attribute
                // list to document.

                // 3.2. For each inclusiveDescendant in node’s shadow-including
                // inclusive descendants that is custom, enqueue a custom element
                // callback reaction with inclusiveDescendant, callback name
                // "adoptedCallback", and an argument list containing oldDocument
                // and document.

                // 3.3. For each inclusiveDescendant in node’s shadow-including
                // inclusive descendants, in shadow-including tree order, run the
                // adopting steps with inclusiveDescendant and oldDocument.
            }

            return node
        }

        func updateLayout() {
            updateStyle()
            let viewportRect = navigable!.viewportRect()
            if layoutRoot == nil {
                let treeBuilder = Layout.TreeBuilder()
                layoutRoot = treeBuilder.build(domNode: self)
                if let _ = documentElement {
                    FIXME("overflow propagation")
                }
            }

            let viewPort = layoutRoot!

            let layoutState = Layout.State()
            let rootFormattingContext = Layout.BlockFormattingContext(
                state: layoutState,
                contextBox: viewPort,
                parent: nil
            )
            let viewportState = layoutState.getMutable(node: viewPort as Layout.NodeWithStyle)
            viewportState.contentHeight = viewportRect.height
            viewportState.contentWidth = viewportRect.width

            if let documentElement,
               let layoutNode = documentElement.layoutNode,
               let node = layoutNode as? Layout.NodeWithStyle
            {
                let icbState = layoutState.getMutable(node: node)
                icbState.contentWidth = viewportRect.width
            }

            rootFormattingContext.run(
                box: viewPort,
                mode: .normal,
                availableSpace: Layout.AvailableSpace(
                    width: .definite(viewportRect.width),
                    height: .definite(viewportRect.height)
                )
            )

            layoutState.commit()
        }
    }
}
