// interface mixin ChildNode {
//   [CEReactions, Unscopable] undefined before((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined after((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined replaceWith((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined remove();
// };

// DocumentType includes ChildNode;

enum NodeOrString {
    case node(DOM.Node)
    case string(DOM.String)
}

protocol ChildNode {
    func before(_ nodes: NodeOrString...)
    func after(_ nodes: NodeOrString...)
    func replaceWith(_ nodes: NodeOrString...)
    func remove()
}

// Element includes ChildNode;
extension DOM.Element {
    func before(_: NodeOrString...) {
        FIXME("not implemented")
    }

    func viableNextSibling(nodes: [NodeOrString]) -> DOM.Node? {
        // first following sibling not in nodes
        var sibling = nextSibling
        while let currentSibling = sibling {
            for case let .node(node) in nodes {
                if node == currentSibling {
                    break
                }
            }
            sibling = currentSibling.nextSibling
        }
        // otherwise null.
        return nil
    }

    // https://dom.spec.whatwg.org/#dom-childnode-after
    func after(_ nodes: NodeOrString...) {
        // 1. Let parent be this’s parent.
        let parent = parentNode

        // 2. If parent is null, then return.
        if parent == nil {
            return
        }

        // 3. Let viableNextSibling be this’s first following sibling not in
        //    nodes; otherwise null.
        let viableNextSibling = viableNextSibling(nodes: nodes)

        // 4. Let node be the result of converting nodes into a node, given
        //    nodes and this’s node document.
        let node = DOM.convertNodesIntoNode(nodes: nodes, document: ownerDocument!)

        // 5. Pre-insert node into parent before viableNextSibling.
        DOM.preInsertBeforeChild(node: node, parent: parent!, child: viableNextSibling)
    }

    func replaceWith(_: NodeOrString...) {
        FIXME("not implemented")
    }

    func remove() {
        FIXME("not implemented")
    }
}

// CharacterData includes ChildNode;
extension DOM.CharacterData: ChildNode {
    func before(_: NodeOrString...) {
        FIXME("not implemented")
    }

    func after(_: NodeOrString...) {}

    func replaceWith(_: NodeOrString...) {
        FIXME("not implemented")
    }

    func remove() {
        FIXME("not implemented")
    }
}
