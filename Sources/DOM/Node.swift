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
  case ENTITY_REFERENCE_NODE = 5  // legacy
  case ENTITY_NODE = 6  // legacy
  case PROCESSING_INSTRUCTION_NODE = 7
  case COMMENT_NODE = 8
  case DOCUMENT_NODE = 9
  case DOCUMENT_TYPE_NODE = 10
  case DOCUMENT_FRAGMENT_NODE = 11
  case NOTATION_NODE = 12  // legacy
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
//   boolean hasChildNodes();

//   [CEReactions] attribute DOMString? nodeValue;
//   [CEReactions] attribute DOMString? textContent;
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
  let childNodes: NodeList<Node> = NodeList<Node>()

  // readonly attribute Document? ownerDocument;
  var ownerDocument: Document?

  // readonly attribute Node? parentNode;
  let parentNode: Node?

  init(ownerDocument: Document? = nil, parentNode: Node? = nil) {
    self.ownerDocument = ownerDocument
    self.parentNode = nil
    super.init()
  }

  // readonly attribute unsigned short nodeType;
  // https://dom.spec.whatwg.org/#dom-node-nodetype
  var nodeType: UInt16 {
    switch type(of: self) {
    case is DocumentType.Type:
      return NodeType.DOCUMENT_TYPE_NODE.rawValue
    case is Element.Type:
      return NodeType.ELEMENT_NODE.rawValue
    case is Attr.Type:
      return NodeType.ATTRIBUTE_NODE.rawValue
    case is Text.Type:
      return NodeType.TEXT_NODE.rawValue
    // case is CDATASection.Type:
    //     return .CDATA_SECTION_NODE
    // case is ProcessingInstruction.Type:
    //     return .PROCESSING_INSTRUCTION_NODE
    case is Comment.Type:
      return NodeType.COMMENT_NODE.rawValue
    case is Document.Type:
      return NodeType.DOCUMENT_NODE.rawValue
    // case is DocumentFragment.Type:
    //     return .DOCUMENT_FRAGMENT_NODE
    default:
      print("\(#function): \(type(of: self)): not implemented")
      assertionFailure()
      return NodeType.ELEMENT_NODE.rawValue
    }
  }

  // readonly attribute DOMString nodeName;
  // https://dom.spec.whatwg.org/#dom-node-nodename
  var nodeName: DOMString? {
    switch type(of: self) {

    // Element
    case is Element.Type:
      let element = self as! Element
      // Its HTML-uppercased qualified name.
      return element.qualifiedName.uppercased()

    // Attr
    case is Attr.Type:
      let attr = self as! Attr
      // Its qualified name.
      return attr.qualifiedName

    // An exclusive Text node
    case is Text.Type /*, is !CDATASection.Type */:
      return "#text"

    // CDATASection
    //   "#cdata-section".

    // ProcessingInstruction
    //   Its target.

    // Comment
    case is Comment.Type:
      return "#comment"

    // Document
    case is Document.Type:
      return "#document"

    // DocumentType
    case is DocumentType.Type:
      return "#document"

    // DocumentFragment
    case is DocumentFragment.Type:
      return "#document-fragment"

    default:
      print("\(#function): \(type(of: self)): not implemented")
      assertionFailure()
      return "nil"
    }
  }

  // readonly attribute Node? firstChild;
  var firstChild: Node? {
    // The first child of an object is its first child or null if it has no children.
    return childNodes.array.first
  }

  // readonly attribute Node? lastChild;
  var lastChild: Node? {
    // The last child of an object is its last child or null if it has no children.
    return childNodes.array.last
  }

  // readonly attribute Node? previousSibling;tree
  // readonly attribute Node? nextSibling;

  // boolean isEqualNode(Node? otherNode);
  func isEqualNode(_ node: Node?) -> Bool {
    return self == node
  }

  // boolean isSameNode(Node? otherNode); // legacy alias of ===
  var isSameNode = isEqualNode

  // [CEReactions] Node insertBefore(Node node, Node? child);
  func insertBefore(_ node: Node, before child: Node?) {
    // To pre-insert a node into a parent before a child, run these steps:

    // Ensure pre-insertion validity of node into parent before child.

    // Let referenceChild be child.

    // If referenceChild is node, then set referenceChild to node’s next sibling.

    // Insert node into parent before referenceChild.

    // Return node.

    if let child = child {
      let index = childNodes.array.firstIndex(of: child)
      childNodes.array.insert(node, at: index!)
    } else {
      childNodes.array.append(node)
    }
  }
  // [CEReactions] Node appendChild(Node node);
  // [CEReactions] Node replaceChild(Node node, Node child);
  // [CEReactions] Node removeChild(Node child);
  func appendChild(_ node: Node) {
    childNodes.array.append(node)
  }

}

extension Node: Equatable {
  public static func == (a: Node, b: Node) -> Bool {
    // A node A equals a node B if all of the following conditions are true:

    // A and B implement the same interfaces.
    guard type(of: a) == type(of: b) else {
      return false
    }

    // The following are equal, switching on the interface A implements:
    switch type(of: a) {
    // DocumentType
    case is DocumentType.Type:
      // Its name, public ID, and system ID.
      let a = a as! DocumentType
      let b = b as! DocumentType
      return a.name == b.name && a.publicId == b.publicId && a.systemId == b.systemId
    // Element
    case is Element.Type:
      // Its namespace, namespace prefix, local name, and its attribute list’s size.
      let a = a as! Element
      let b = b as! Element
      return a.namespaceURI == b.namespaceURI
        && /* a.prefix == b.prefix && a.localName == b.localName && */ a.attributes.length
          == b.attributes.length
    // Attr
    case is Attr.Type:
      // Its namespace, namespace prefix, local name, and value.
      let a = a as! Attr
      let b = b as! Attr
      return a.namespaceURI == b.namespaceURI
        && /* a.prefix == b.prefix && a.localName == b.localName && */ a.value == b.value
    // ProcessingInstruction
    // Its target and data.
    // Text
    case is Text.Type:
      // Its data.
      let a = a as! Text
      let b = b as! Text
      return a.data == b.data
    // Comment
    case is Comment.Type:
      // Its data.
      let a = a as! Comment
      let b = b as! Comment
      return a.data == b.data

    // Otherwise
    default:
      // —
      return false
    }
  }
}

func isInclusiveAncestor(node: Node, ancestor: Node) -> Bool {
  // An inclusive ancestor is an object or one of its ancestors.
  let parent = node.parentNode
  if parent == nil {
    return false
  }
  if parent == ancestor {
    return true
  }
  while let parent = parent {
    if parent == ancestor {
      return true
    }
  }
  return false
}

func rootOf(node: Node) -> Node {
  // The root of an object is itself, if its parent is null, or else it is the
  // root of its parent. The root of a tree is any object participating in
  // that tree whose parent is null.
  var currentNode = node
  while let parent = currentNode.parentNode {
    currentNode = parent
  }
  return currentNode
}

func isHostIncludingInclusiveAncestor(a: Node, b: Node) -> Bool {
  // An object A is a host-including inclusive ancestor of an object B, if either
  // A is an inclusive ancestor of B, or if B’s root has a non-null host and A is
  // a host-including inclusive ancestor of B’s root’s host.

  if isInclusiveAncestor(node: a, ancestor: b) {
    return true
  }

  // if let bRoot = rootOf(node: b), let bRootHost: Node? = nil {
  //     return isHostIncludingInclusiveAncestor(a: a, b: bRootHost)
  // }

  return false
}
// https://dom.spec.whatwg.org/#concept-node-ensure-pre-insertion-validity
func ensurePreInsertValidation(node: Node, parent: Node, child: Node?) throws {
  // If parent is not a Document, DocumentFragment, or Element node, then throw a
  // "HierarchyRequestError" DOMException.
  guard parent is Document || parent is DocumentFragment || parent is Element else {
    throw DOMException.hierarchyRequestError
  }

  // If node is a host-including inclusive ancestor of parent, then throw a
  // "HierarchyRequestError" DOMException.
  guard !isHostIncludingInclusiveAncestor(a: node, b: parent) else {
    throw DOMException.hierarchyRequestError
  }

  // If child is non-null and its parent is not parent, then throw a
  // "NotFoundError" DOMException.
  if let child = child, child.parentNode != parent {
    throw DOMException.notFoundError
  }

  // If node is not a DocumentFragment, DocumentType, Element, or CharacterData
  // node, then throw a "HierarchyRequestError" DOMException.
  guard node is DocumentFragment || node is DocumentType || node is Element || node is CharacterData
  else {
    throw DOMException.hierarchyRequestError
  }

  // If either node is a Text node and parent is a document, or node is a doctype
  // and parent is not a document, then throw a "HierarchyRequestError"
  // DOMException.
  if (node is Text && parent is Document) || (node is DocumentType && !(parent is Document)) {
    throw DOMException.hierarchyRequestError
  }

  // If parent is a document, and any of the statements below, switched on the
  // interface node implements, are true, then throw a "HierarchyRequestError"
  // DOMException.
  if parent is Document {
    switch node {
    // DocumentFragment
    case is DocumentFragment:
      print("\(#function): DocumentFragment not implemented")
    // If node has more than one element child or has a Text node child.
    // Otherwise, if node has one element child and either parent has an
    // element child, child is a doctype, or child is non-null and a doctype
    // is following child.

    // Element
    case is Element:
      // parent has an element child, child is a doctype, or child is non-null
      // and a doctype is following child.
      if parent.childNodes.array.allSatisfy({ $0 is Element }), child is DocumentType/* || (child != nil && parent.hasFollowingDoctype(child!) )*/
      {
        throw DOMException.hierarchyRequestError
      }
    // DocumentType
    case is DocumentType:
      print("\(#function): DocumentType not implemented")
    default:
      break
    }
  }
}
