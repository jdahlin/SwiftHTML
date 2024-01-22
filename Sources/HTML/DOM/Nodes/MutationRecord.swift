// [Exposed=Window]
// interface MutationRecord {
//   readonly attribute DOMString type;
//   [SameObject] readonly attribute Node target;
//   [SameObject] readonly attribute NodeList addedNodes;
//   [SameObject] readonly attribute NodeList removedNodes;
//   readonly attribute Node? previousSibling;
//   readonly attribute Node? nextSibling;
//   readonly attribute DOMString? attributeName;
//   readonly attribute DOMString? attributeNamespace;
//   readonly attribute DOMString? oldValue;
// };

class MutationRecord {}

func queueMutationRecord(
    addedNodes: [Node],
    removedNodes: [Node],
    previousSibling _: Node?,
    nextSibling _: Node?
) {
    // Assert: either addedNodes or removedNodes is not empty.
    assert(!addedNodes.isEmpty || !removedNodes.isEmpty)

    // Queue a mutation record of "childList" for target with null, null, null,
    // addedNodes, removedNodes, previousSibling, and nextSibling.
    FIXME("queue mutation record")
}
