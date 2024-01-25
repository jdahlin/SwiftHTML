extension DOM {
    // https://dom.spec.whatwg.org/#concept-tree-root
    static func rootOf(node: DOM.Node) -> DOM.Node {
        // The root of an object is itself, if its parent is null, or else it is the
        // root of its parent. The root of a tree is any object participating in
        // that tree whose parent is null.
        var currentNode = node
        while let parent = currentNode.parentNode {
            currentNode = parent
        }
        return currentNode
    }

    // https://dom.spec.whatwg.org/#concept-tree-inclusive-ancestor
    static func isInclusiveAncestor(node: DOM.Node, ancestor: DOM.Node) -> Bool {
        // An inclusive ancestor is an object or one of its ancestors.
        let parent = node.parentNode
        if parent == nil {
            return false
        }
        if parent == ancestor {
            return true
        }
        while let parent {
            if parent == ancestor {
                return true
            }
        }
        return false
    }

    struct DescendantsIterator: IteratorProtocol, Sequence {
        private var currentNode: DOM.Node?

        init(element: DOM.Element, nodeType _: DOM.Node.Type = DOM.Element.self) {
            currentNode = element.firstChild
        }

        mutating func next() -> DOM.Element? {
            while let node = currentNode {
                currentNode = node.nextSibling
                if let element = node as? DOM.Element {
                    return element
                }
            }
            return nil
        }
    }

    static func getDescendants(element: DOM.Element) -> DescendantsIterator {
        DescendantsIterator(element: element)
    }

    static func isDescendantOf(element: DOM.Element, ancestor: DOM.Element) -> Bool {
        var node = element.parentNode
        while node != nil {
            if node == ancestor {
                return true
            }
            node = node?.parentNode
        }
        return false
    }

    // func nodesInTreeOrder(nodes: [DOM.Node], visit: (DOM.Node) -> Void) {
//     for node in nodes {
//         visit(node)
//         if let element = node as? DOM.Element {
//             nodesInTreeOrder(nodes: element.childNodes, visit: visit)
//         }
//     }
    // }
}
