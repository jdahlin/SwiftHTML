// interface mixin ParentNode {
//   [SameObject] readonly attribute HTMLCollection children;
//   readonly attribute Element? firstElementChild;
//   readonly attribute Element? lastElementChild;
//   readonly attribute unsigned long childElementCount;

//   [CEReactions, Unscopable] undefined prepend((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined append((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined replaceChildren((Node or DOMString)... nodes);

//   Element? querySelector(DOMString selectors);
//   [NewObject] NodeList querySelectorAll(DOMString selectors);
// };
// Document includes ParentNode;
// DocumentFragment includes ParentNode;
// Element includes ParentNode;

// https://dom.spec.whatwg.org/#converting-nodes-into-a-node
func convertNodesIntoNode(nodes: [NodeOrString], document: Document) -> Node {
    // 1. Let node be null.
    var node: Node? = nil

    // 2. Replace each string in nodes with a new Text node whose data is the
    //    string and node document is document.
    let convertedNodes: [Node] = nodes.map { nodeOrString -> Node in
        switch nodeOrString {
        case let .node(node):
            return node
        case let .string(string):
            return Text(data: string, ownerDocument: document)
        }
    }

    // 3. If nodes contains one node, then set node to nodes[0].
    if convertedNodes.count == 1 {
        node = convertedNodes[0]
    }
    // 4. Otherwise, set node to a new DocumentFragment node whose node document
    //    is document, and then append each node in nodes, if any, to it.
    else {
        node = DocumentFragment(ownerDocument: document)
        for convertedNode in convertedNodes {
            node!.appendChild(node: convertedNode)
        }
    }

    // 5. Return node.
    return node!
}
