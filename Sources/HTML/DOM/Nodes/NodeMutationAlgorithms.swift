// 4.2.3. https://dom.spec.whatwg.org/#mutation-algorithms

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
            DIE("DocumentFragment not implemented")
    // If node has more than one element child or has a Text node child.
    // Otherwise, if node has one element child and either parent has an
    // element child, child is a doctype, or child is non-null and a doctype
    // is following child.

        // Element
        case is Element:
            // parent has an element child, child is a doctype, or child is non-null
            // and a doctype is following child.
            if Array(parent.childNodes).allSatisfy({ $0 is Element }), child is DocumentType /* || (child != nil && parent.hasFollowingDoctype(child!) )*/
            {
                throw DOMException.hierarchyRequestError
            }
        // DocumentType
        case is DocumentType:
            DIE("DocumentType not implemented")
        default:
            break
        }
    }
}

// https://dom.spec.whatwg.org/#concept-node-pre-insert
@discardableResult func preInsertBeforeChild(node: Node, parent: Node, child: Node?) -> Node {
    // 1. Ensure pre-insertion validity of node into parent before child.
    let result = Result { try ensurePreInsertValidation(node: node, parent: parent, child: child) }
    guard case .success = result else {
        FIXME("\(result)")
        return node
    }

    // 2. Let referenceChild be child.
    var referenceChild = child

    // 3. If referenceChild is node, then set referenceChild to node’s next sibling.
    if referenceChild == node {
        referenceChild = node.nextSibling
    }

    // 4. Insert node into parent before referenceChild.
    insertNodeIntoParent(
        node: node,
        parent: parent,
        child: referenceChild,
        suppressObservers: false
    )

    // 5. Return node.
    return node
}

// https://dom.spec.whatwg.org/#concept-node-insert
func insertNodeIntoParent(node: Node,
                          parent: Node,
                          child: Node?,
                          suppressObservers _: Bool)
{
    // 1. Let nodes be node’s children, if node is a DocumentFragment node; otherwise « node ».
    let nodes = if let fragment = node as? DocumentFragment {
        Array(fragment.childNodes)
    } else {
        [node]
    }

    // 2. Let count be nodes’s size.
    let count = nodes.count

    // 3. If count is 0, then return.
    if count == 0 {
        return
    }

    // 4. If node is a DocumentFragment node, then:
    if let _ = node as? DocumentFragment {
        // 4.1. Remove its children with the suppress observers flag set.
        for child in nodes {
            removeNode(node: child, suppressObservers: true)
        }

        // 4.2. Queue a tree mutation record for node with « », nodes, null, and null.
        queueMutationRecord(addedNodes: [], removedNodes: nodes, previousSibling: nil, nextSibling: nil)

        // Note: This step intentionally does not pay attention to the suppress observers flag.
    }

    // 5. If child is non-null, then:
    if let child = child {
        // FIXME:
        _ = child
        // 5.1. For each live range whose start node is parent and start offset
        //      is greater than child’s index, increase its start offset by count.

        // 5.2. For each live range whose end node is parent and end offset
        //      is greater than child’s index, increase its end offset by count.
    }

    // 6. Let previousSibling be child’s previous sibling or parent’s last child if child is null.
    _ = child?.previousSibling ?? parent.lastChild

    // 7. For each node in nodes, in tree order:

    for node in nodes {
        // 7.1. Adopt node into parent’s node document.
        _ = parent.ownerDocument!.adoptNode(node: node)

        // 7.2. If child is null, then append node to parent’s children.
        if child == nil {
            appendChildImpl(parent: parent, node: node)
        }
        // 7.3. Otherwise, insert node into parent’s children before child’s index.
        else {
            insertBeforeImpl(parent: parent, node: node, child: child)
        }

        // 7.4. If parent is a shadow host whose shadow root’s slot
        //      assignment is "named" and node is a slottable, then assign a
        //      slot for node.

        // 7.5. If parent’s root is a shadow root, and parent is a slot
        //      whose assigned nodes is the empty list, then run signal a
        //      slot change for parent.

        // 7.6. Run assign slottables for a tree with node’s root.

        // 7.7. For each shadow-including inclusive descendant
        //      inclusiveDescendant of node, in shadow-including tree order:

        // 7.7.1. Run the insertion steps with inclusiveDescendant.

        // 7.7.2. If inclusiveDescendant is connected, then:

        // 7.7.2.1. If inclusiveDescendant is custom, then enqueue a custom
        //          element callback reaction with inclusiveDescendant,
        //          callback name "connectedCallback", and an empty argument
        //          list.

        // 7.7.2.2. Otherwise, try to upgrade inclusiveDescendant.

        // Note: If this successfully upgrades inclusiveDescendant, its
        //       connectedCallback will be enqueued automatically during the
        //       upgrade an element algorithm.
    }

    // If suppress observers flag is unset, then queue a tree mutation
    // record for parent with nodes, « », previousSibling, and child.

    // Run the children changed steps for parent.
}

// https://dom.spec.whatwg.org/#concept-node-append
func appendNodeToParent(node: Node, parent: Node) -> Node {
    // To append a node to a parent, pre-insert node into parent before null.
    return preInsertBeforeChild(node: node, parent: parent, child: nil)
}

// https://dom.spec.whatwg.org/#concept-node-replace
func replaceChild(child: Node, node: Node, parent _: Node) -> Node {
    // 1. If parent is not a Document, DocumentFragment, or Element node, then
    //    throw a "HierarchyRequestError" DOMException.

    // 2. If node is a host-including inclusive ancestor of parent, then throw a
    //    "HierarchyRequestError" DOMException.

    // 3. If child’s parent is not parent, then throw a "NotFoundError" DOMException.

    // 4. If node is not a DocumentFragment, DocumentType, Element, or
    //    CharacterData node, then throw a "HierarchyRequestError" DOMException.

    // 5. If either node is a Text node and parent is a document, or node is a
    //    doctype and parent is not a document, then throw a
    //    "HierarchyRequestError" DOMException.

    // 6. If parent is a document, and any of the statements below, switched on
    //    the interface node implements, are true, then throw a
    //    "HierarchyRequestError" DOMException.
    switch node {
    // DocumentFragment
    case is DocumentFragment:
        // If node has more than one element child or has a Text node child.
        // Otherwise, if node has one element child and either parent has an
        // element child that is not child or a doctype is following child.
        DIE("DocumentFragment not implemented")
    // Element
    case is Element:
        // parent has an element child that is not child or a doctype is
        // following child.
        DIE("Element not implemented")
    // DocumentType
    case is DocumentType:
        // parent has a doctype child that is not child, or an element is preceding child.
        DIE("DocumentType not implemented")
    default:
        break
        // Note: The above statements differ from the pre-insert algorithm.
    }

    // 7. Let referenceChild be child’s next sibling.
    var referenceChild = child.nextSibling

    // 8. If referenceChild is node, then set referenceChild to node’s next sibling.
    if referenceChild == node {
        referenceChild = node.nextSibling
    }

    // 9. Let previousSibling be child’s previous sibling.
    let previousSibling = child.previousSibling

    // 10. Let removedNodes be the empty set.
    var removedNodes = Set<Node>()

    // 11. If child’s parent is non-null, then:
    if child.parentNode != nil {
        // 11.1 Set removedNodes to « child ».
        removedNodes.insert(child)

        // 11.2. Remove child with the suppress observers flag set.
        removeNode(node: child, suppressObservers: true)

        // Note: The above can only be false if child is node.
    }

    // 12. Let nodes be node’s children if node is a DocumentFragment node; otherwise « node ».
    let nodes = if let fragment = node as? DocumentFragment {
        Array(fragment.childNodes)
    } else {
        [node]
    }

    // 13. Insert node into parent before referenceChild with the suppress observers flag set.
    insertNodeIntoParent(node: node, parent: child.parentNode!, child: child.nextSibling,
                         suppressObservers: true)

    // 14. Queue a tree mutation record for parent with nodes, removedNodes, previousSibling, and referenceChild.
    queueMutationRecord(
        addedNodes: nodes,
        removedNodes: Array(removedNodes),
        previousSibling: previousSibling,
        nextSibling: referenceChild
    )

    // 15. Return child.
    return child
}

// https://dom.spec.whatwg.org/#concept-node-replace-all
func replaceAll(node: Node?, parent: Node) {
    // 1. Let removedNodes be parent’s children.
    let removedNodes = parent.childNodes

    // 2. Let addedNodes be the empty set.
    var addedNodes = Set<Node>()

    // 3. If node is a DocumentFragment node, then set addedNodes to node’s children.
    if let fragment = node as? DocumentFragment {
        addedNodes = Set(fragment.childNodes)
        // 4. Otherwise, if node is non-null, set addedNodes to « node ».
    } else if node != nil {
        addedNodes = Set([node!])
    }

    // 5. Remove all parent’s children, in tree order, with the suppress observers flag set.
    for child in parent.childNodes {
        removeNode(node: child, suppressObservers: true)
    }

    // 6. If node is non-null, then insert node into parent before null with the
    //    suppress observers flag set.
    if node != nil {
        insertNodeIntoParent(node: node!, parent: parent, child: nil,
                             suppressObservers: true)
    }

    // 7. If either addedNodes or removedNodes is not empty, then queue a tree
    //    mutation record for parent with addedNodes, removedNodes, null, and
    //    null.
    if !addedNodes.isEmpty || removedNodes.length > 0 {
        queueMutationRecord(
            addedNodes: Array(addedNodes),
            removedNodes: Array(removedNodes),
            previousSibling: nil,
            nextSibling: nil
        )
    }

    // Note: This algorithm does not make any checks with regards to the node
    // tree constraints. Specification authors need to use it wisely.
}

func removeNode(node: Node, suppressObservers _: Bool = false) {
    // 1. Let parent be node’s parent.
    let parentOrNil = node.parentNode

    // 2. Assert: parent is non-null.
    assert(parentOrNil != nil)

    let parent = parentOrNil!

    // 3. Let index be node’s index.
    _ = Array(parent.childNodes).firstIndex(of: node)

    // 4. For each live range whose start node is an inclusive descendant of
    //    node, set its start to (parent, index).

    // 5. For each live range whose end node is an inclusive descendant of node,
    //    set its end to (parent, index).

    // 6. For each live range whose start node is parent and start offset is
    //    greater than index, decrease its start offset by 1.

    // 7. For each live range whose end node is parent and end offset is greater
    //    than index, decrease its end offset by 1.

    // 8. For each NodeIterator object iterator whose root’s node document is
    //    node’s node document, run the NodeIterator pre-removing steps given
    //    node and iterator.

    // 9. Let oldPreviousSibling be node’s previous sibling.
    _ = node.previousSibling

    // 10. Let oldNextSibling be node’s next sibling.
    _ = node.nextSibling

    // 11. Remove node from its parent’s children.
    removeChildImpl(parent: parent, node: node)

    // 12. If node is assigned, then run assign slottables for node’s assigned slot.

    // 13. If parent’s root is a shadow root, and parent is a slot whose
    //     assigned nodes is the empty list, then run signal a slot change for
    //     parent.

    // 14. If node has an inclusive descendant that is a slot, then:

    // 14.1. Run assign slottables for a tree with parent’s root.

    // 14.2. Run assign slottables for a tree with node.

    // 15. Run the removing steps with node and parent.

    // 16. Let isParentConnected be parent’s connected.

    // 17. If node is custom and isParentConnected is true, then enqueue a
    //     custom element callback reaction with node, callback name
    //     "disconnectedCallback", and an empty argument list.

    // Note: It is intentional for now that custom elements do not get parent
    //       passed. This might change in the future if there is a need.

    // 18. For each shadow-including descendant descendant of node, in shadow-including tree order, then:

    // 18.1. Run the removing steps with descendant and null.

    // 18.2. If descendant is custom and isParentConnected is true, then enqueue
    //       a custom element callback reaction with descendant, callback name
    //       "disconnectedCallback", and an empty argument list.

    // 19. For each inclusive ancestor inclusiveAncestor of parent, and then for
    //     each registered of inclusiveAncestor’s registered observer list, if
    //     registered’s options["subtree"] is true, then append a new transient
    //     registered observer whose observer is registered’s observer, options
    //     is registered’s options, and source is registered to node’s
    //     registered observer list.

    // 20. If suppress observers flag is unset, then queue a tree mutation
    //     record for parent with « », « node », oldPreviousSibling, and
    //     oldNextSibling.

    // 21. Run the children changed steps for parent.
}

func isChildAllowed(node: Node) -> Bool {
    return switch node {
    case is Document: false
    case is Text: true
    case is Comment: true
    case is DocumentType: !(node.firstChild is DocumentType)
    case is Element: !(node.firstChild is Element)
    default: false
    }
}

func appendChildImpl(parent: Node, node: Node) {
    assert(node.parentNode == nil)

    guard isChildAllowed(node: node) else {
        return
    }

    if parent.lastChild != nil {
        parent.lastChild!.nextSibling = node
    }

    node.previousSibling = parent.lastChild
    node.parentNode = parent

    parent.lastChild = node
    if parent.firstChild == nil {
        parent.firstChild = parent.lastChild
    }
}

func insertBeforeImpl(parent: Node, node: Node, child childOrNone: Node?) {
    if childOrNone == nil {
        appendChildImpl(parent: parent, node: node)
        return
    }

    let child = childOrNone!
    assert(node.parentNode == nil)
    assert(child.parentNode == parent)

    node.previousSibling = child.previousSibling
    node.nextSibling = child

    if child.previousSibling != nil {
        child.previousSibling!.nextSibling = node
    }
    if parent.firstChild == child {
        parent.firstChild = node
    }
    child.previousSibling = node

    node.parentNode = parent
}

func removeChildImpl(parent: Node, node: Node) {
    if parent.firstChild == node {
        parent.firstChild = node.nextSibling
    }

    if parent.lastChild == node {
        parent.lastChild = node.previousSibling
    }

    if node.nextSibling != nil {
        node.nextSibling!.previousSibling = node.previousSibling
    }

    if node.previousSibling != nil {
        node.previousSibling!.nextSibling = node.nextSibling
    }
    node.nextSibling = nil
    node.previousSibling = nil
    node.parentNode = nil
}
