// const unsigned short ELEMENT_NODE = 1;
// const unsigned short ATTRIBUTE_NODE = 2;
// const unsigned short TEXT_NODE = 3;
// const unsigned short CDATA_SECTION_NODE = 4;
// const unsigned short ENTITY_REFERENCE_NODE = 5; // legacy
// const unsigned short ENTITY_NODE = 6; // legacy
// const unsigned short PROCESSING_INSTRUCTION_NODE = 7;
// const unsigned short COMMENT_NODE = 8;
// const unsigned short DOCUMENT_NODE = 9;
// const unsigned short DOCUMENT_TYPE_NODE = 10;
// const unsigned short DOCUMENT_FRAGMENT_NODE = 11;
// const unsigned short NOTATION_NODE = 12; // legacy
enum NodeType: UInt16 {
    case ELEMENT_NODE = 1
    case ATTRIBUTE_NODE = 2
    case TEXT_NODE = 3
    case CDATA_SECTION_NODE = 4
    case ENTITY_REFERENCE_NODE = 5 // legacy
    case ENTITY_NODE = 6 // legacy
    case PROCESSING_INSTRUCTION_NODE = 7
    case COMMENT_NODE = 8
    case DOCUMENT_NODE = 9
    case DOCUMENT_TYPE_NODE = 10
    case DOCUMENT_FRAGMENT_NODE = 11
    case NOTATION_NODE = 12 // legacy
}

// const unsigned short DOCUMENT_POSITION_DISCONNECTED = 0x01;
// const unsigned short DOCUMENT_POSITION_PRECEDING = 0x02;
// const unsigned short DOCUMENT_POSITION_FOLLOWING = 0x04;
// const unsigned short DOCUMENT_POSITION_CONTAINS = 0x08;
// const unsigned short DOCUMENT_POSITION_CONTAINED_BY = 0x10;
// const unsigned short DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0x20;
enum DocumentPosition: UInt16 {
    case DISCONNECTED = 0x01
    case PRECEDING = 0x02
    case FOLLOWING = 0x04
    case CONTAINS = 0x08
    case CONTAINED_BY = 0x10
    case IMPLEMENTATION_SPECIFIC = 0x20
}

// [Exposed=Window]
// interface Node : EventTarget {

//   readonly attribute USVString baseURI;
//   readonly attribute boolean isConnected;
//   Node getRootNode(optional GetRootNodeOptions options = {});
//   readonly attribute Element? parentElement;

//   [CEReactions] attribute DOMString? nodeValue;
//   [CEReactions] undefined normalize();

//   [CEReactions, NewObject] Node cloneNode(optional boolean deep = false);

//   unsigned short compareDocumentPosition(Node other);
//   boolean contains(Node? other);

//   DOMString? lookupPrefix(DOMString? namespace);
//   DOMString? lookupNamespaceURI(DOMString? prefix);
//   boolean isDefaultNamespace(DOMString? namespace);

// };

public class Node: EventTarget {
    // [SameObject] readonly attribute NodeList childNodes;
    let childNodes: LiveNodeList<Node>

    // readonly attribute Document? ownerDocument;
    var ownerDocument: Document?

    // readonly attribute Node? parentNode;
    var parentNode: Node?

    init(ownerDocument: Document? = nil, parentNode _: Node? = nil) {
        self.ownerDocument = ownerDocument
        parentNode = nil
        childNodes = LiveNodeList()
        super.init()
        childNodes.root = self
    }

    // readonly attribute unsigned short nodeType;
    // https://dom.spec.whatwg.org/#dom-node-nodetype
    var nodeType: UInt16 {
        switch self {
        case is DocumentType:
            NodeType.DOCUMENT_TYPE_NODE.rawValue
        case is Element:
            NodeType.ELEMENT_NODE.rawValue
        case is Attr:
            NodeType.ATTRIBUTE_NODE.rawValue
        case is Text:
            NodeType.TEXT_NODE.rawValue
        // case is CDATASection:
        //     return .CDATA_SECTION_NODE
        case is ProcessingInstruction:
            NodeType.PROCESSING_INSTRUCTION_NODE.rawValue
        case is Comment:
            NodeType.COMMENT_NODE.rawValue
        case is Document:
            NodeType.DOCUMENT_NODE.rawValue
        case is DocumentFragment:
            NodeType.DOCUMENT_FRAGMENT_NODE.rawValue
        default:
            DIE("\(type(of: self)): not implemented")
        }
    }

    // readonly attribute DOMString nodeName;
    // https://dom.spec.whatwg.org/#dom-node-nodename
    var nodeName: DOMString? {
        switch self {
        // Element
        case let element as Element:
            // Its HTML-uppercased qualified name.
            element.qualifiedName.uppercased()

        // Attr
        case let attr as Attr:
            // Its qualified name.
            attr.qualifiedName

        // An exclusive Text node
        case is Text /* , is !CDATASection.Type */:
            "#text"

    // CDATASection
    //   "#cdata-section".

        // ProcessingInstruction
        case let processingInstruction as ProcessingInstruction:
            // Its target.
            processingInstruction.target

        // Comment
        case is Comment:
            "#comment"

        // Document
        case is Document:
            "#document"

        // DocumentType
        case is DocumentType:
            "#document"

        // DocumentFragment
        case is DocumentFragment:
            "#document-fragment"

        default:
            DIE("\(type(of: self)): not implemented")
        }
    }

    // https://dom.spec.whatwg.org/#dom-node-textcontent
    var textContent: String? {
        switch self {
        case is DocumentFragment:
            // The descendant text content of this.
            descendantTextContent(node: self)
        case is Element:
            // The descendant text content of this.
            descendantTextContent(node: self)
        case let attr as Attr:
            // The value of this.
            attr.value
        case let charData as CharacterData:
            // The data of this.
            charData.data
        default:
            nil
        }
    }

    // readonly attribute Node? firstChild;
    // https://dom.spec.whatwg.org/#dom-node-firstchild
    var firstChild: Node?

    // readonly attribute Node? lastChild;
    // https://dom.spec.whatwg.org/#dom-node-lastchild
    var lastChild: Node?

    // boolean hasChildNodes();
    // https://dom.spec.whatwg.org/#dom-node-haschildnodes
    func hasChildNodes() -> Bool {
        // The hasChildNodes() method steps are to return true if this has
        // children; otherwise false.
        childNodes.length > 0
    }

    // boolean isEqualNode(Node? otherNode);
    // https://dom.spec.whatwg.org/#dom-node-isequalnode
    func isEqualNode(_ node: Node?) -> Bool {
        // The isEqualNode(otherNode) method steps are to return true if
        // otherNode is non-null and this equals otherNode; otherwise false.
        self == node
    }

    // boolean isSameNode(Node? otherNode);
    // https://dom.spec.whatwg.org/#dom-node-issamenode
    var isSameNode =
        // legacy alias of ===
        isEqualNode

    // readonly attribute Node? previousSibling;tree
    // https://dom.spec.whatwg.org/#concept-tree-previous-sibling
    var previousSibling: Node?

    // readonly attribute Node? nextSibling;
    // https://dom.spec.whatwg.org/#concept-tree-next-sibling
    var nextSibling: Node?

    // [CEReactions] Node insertBefore(Node node, Node? child);
    // https://dom.spec.whatwg.org/#dom-node-insertbefore
    @discardableResult func insertBefore(node: Node, before child: Node?) -> Node {
        // The insertBefore(node, child) method steps are to return the result
        // of pre-inserting node into this before child.
        preInsertBeforeChild(node: node, parent: self, child: child)
    }

    // [CEReactions] Node appendChild(Node node);
    // https://dom.spec.whatwg.org/#dom-node-appendchild
    @discardableResult func appendChild(node: Node) -> Node {
        // The appendChild(node) method steps are to return the result of
        // appending node to this.
        appendNodeToParent(node: node, parent: self)
    }

    // [CEReactions] Node replaceChild(Node node, Node child);
    // https://dom.spec.whatwg.org/#dom-node-replacechild
    func replaceChild(_: Node, _: Node) -> Node {
        DIE("not implemented")
    }

    // [CEReactions] Node removeChild(Node child);
    // https://dom.spec.whatwg.org/#dom-node-removechild
    func removeChild(_: Node) -> Node {
        DIE("not implemented")
    }
}
