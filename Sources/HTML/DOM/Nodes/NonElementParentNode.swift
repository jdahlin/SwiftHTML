// interface mixin NonElementParentNode {
//   Element? getElementById(DOMString elementId);
// };
// Document includes NonElementParentNode;
// DocumentFragment includes NonElementParentNode;

extension Document {
    func getElementById(elementId: DOMString) -> Element? {
        // Returns the first element within node’s descendants whose ID is elementId.
        guard let documentElement else {
            return nil
        }
        return getDescendants(element: documentElement).first { $0.id == elementId }
    }
}
