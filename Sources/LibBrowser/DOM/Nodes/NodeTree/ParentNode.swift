// interface mixin ParentNode {
//   [SameObject] readonly attribute HTMLCollection children;
//   readonly attribute DOM.Element? firstDOM.ElementChild;
//   readonly attribute DOM.Element? lastDOM.ElementChild;
//   readonly attribute unsigned long childDOM.ElementCount;

//   [CEReactions, Unscopable] undefined prepend((Node or DOM.String)... nodes);
//   [CEReactions, Unscopable] undefined append((Node or DOM.String)... nodes);
//   [CEReactions, Unscopable] undefined replaceChildren((Node or DOM.String)... nodes);
// };
// Document includes ParentNode;
// DocumentFragment includes ParentNode;
// DOM.Element includes ParentNode;

package extension DOM.Element {
    // DOM.Element? querySelector(DOM.String selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselector
    func querySelector(_ selectors: DOM.String) -> DOM.Element? {
        // The querySelector(selectors) method steps are to return the first
        // result of running scope-match a selectors string selectors against
        // this, if the result is not an empty list; otherwise null.
        let result = CSS.scopeMatchSelectorsString(selectors: selectors, node: self)
        if result.isEmpty {
            return nil
        }
        return result.first
    }

    // [NewObject] NodeList querySelectorAll(DOM.String selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselectorall
    func querySelectorAll(_ selectors: DOM.String) -> [DOM.Element] {
        // The querySelectorAll(selectors) method steps are to return the static
        // result of running scope-match a selectors string selectors against
        // this.
        FIXME("Return a NodeList instead of [DOM.Element]")
        return CSS.scopeMatchSelectorsString(selectors: selectors, node: self)
    }
}

extension DOM {
    // https://dom.spec.whatwg.org/#converting-nodes-into-a-node
    static func convertNodesIntoNode(nodes: [NodeOrString], document: DOM.Document) -> DOM.Node {
        // 1. Let node be null.
        var node: DOM.Node? = nil

        // 2. Replace each string in nodes with a new Text node whose data is the
        //    string and node document is document.
        let convertedNodes: [DOM.Node] = nodes.map { nodeOrString -> DOM.Node in
            switch nodeOrString {
            case let .node(node):
                return node
            case let .string(string):
                return DOM.Text(data: string, ownerDocument: document)
            }
        }

        // 3. If nodes contains one node, then set node to nodes[0].
        if convertedNodes.count == 1 {
            node = convertedNodes[0]
        }
        // 4. Otherwise, set node to a new DocumentFragment node whose node document
        //    is document, and then append each node in nodes, if any, to it.
        else {
            node = DOM.DocumentFragment(ownerDocument: document)
            for convertedNode in convertedNodes {
                node!.appendChild(node: convertedNode)
            }
        }

        // 5. Return node.
        return node!
    }
}
