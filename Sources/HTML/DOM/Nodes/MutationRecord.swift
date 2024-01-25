// [Exposed=Window]
// interface MutationRecord {
//   readonly attribute DOM.String type;
//   [SameObject] readonly attribute Node target;
//   [SameObject] readonly attribute NodeList addedNodes;
//   [SameObject] readonly attribute NodeList removedNodes;
//   readonly attribute Node? previousSibling;
//   readonly attribute Node? nextSibling;
//   readonly attribute DOM.String? attributeName;
//   readonly attribute DOM.String? attributeNamespace;
//   readonly attribute DOM.String? oldValue;
// };

extension DOM {
    class MutationRecord {}

    static func queueMutationRecord(
        addedNodes: [DOM.Node],
        removedNodes: [DOM.Node],
        previousSibling _: DOM.Node?,
        nextSibling _: DOM.Node?
    ) {
        // Assert: either addedNodes or removedNodes is not empty.
        assert(!addedNodes.isEmpty || !removedNodes.isEmpty)

        // Queue a mutation record of "childList" for target with null, null, null,
        // addedNodes, removedNodes, previousSibling, and nextSibling.
        FIXME("queue mutation record")
    }
}
