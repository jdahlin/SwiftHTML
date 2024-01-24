// interface mixin ParentNode {
//   [SameObject] readonly attribute HTMLCollection children;
//   readonly attribute Element? firstElementChild;
//   readonly attribute Element? lastElementChild;
//   readonly attribute unsigned long childElementCount;

//   [CEReactions, Unscopable] undefined prepend((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined append((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined replaceChildren((Node or DOMString)... nodes);
// };
// Document includes ParentNode;
// DocumentFragment includes ParentNode;
// Element includes ParentNode;

package extension Element {
    // Element? querySelector(DOMString selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselector
    func querySelector(_ selectors: DOMString) -> Element? {
        // The querySelector(selectors) method steps are to return the first
        // result of running scope-match a selectors string selectors against
        // this, if the result is not an empty list; otherwise null.
        let result = scopeMatchSelectorsString(selectors: selectors, node: self)
        if result.isEmpty {
            return nil
        }
        return result.first
    }

    // [NewObject] NodeList querySelectorAll(DOMString selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselectorall
    func querySelectorAll(_ selectors: DOMString) -> [Element] {
        // The querySelectorAll(selectors) method steps are to return the static
        // result of running scope-match a selectors string selectors against
        // this.
        FIXME("Return a NodeList instead of [Element]")
        return scopeMatchSelectorsString(selectors: selectors, node: self)
    }
}

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
