// https://dom.spec.whatwg.org/#concept-tree-root
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

// https://dom.spec.whatwg.org/#concept-tree-inclusive-ancestor
func isInclusiveAncestor(node: Node, ancestor: Node) -> Bool {
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

func getDescendants(element: Element) -> [Element] {
    var descendants: [Element] = []
    if element.firstChild != nil {
        var node = element.firstChild
        repeat {
            node = node?.nextSibling
            if node is Element {
                descendants.append(node as! Element)
            }
        } while node?.nextSibling != nil
    }
    return descendants
}

func isDescendantOf(element: Element, ancestor: Element) -> Bool {
    var node = element.parentNode
    while node != nil {
        if node == ancestor {
            return true
        }
        node = node?.parentNode
    }
    return false
}

// func nodesInTreeOrder(nodes: [Node], visit: (Node) -> Void) {
//     for node in nodes {
//         visit(node)
//         if let element = node as? Element {
//             nodesInTreeOrder(nodes: element.childNodes, visit: visit)
//         }
//     }
// }
