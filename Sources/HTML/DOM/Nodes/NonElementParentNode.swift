// interface mixin NonDOM.ElementParentNode {
//   DOM.Element? getDOM.ElementById(DOM.String elementId);
// };
// Document includes NonDOM.ElementParentNode;
// DocumentFragment includes NonDOM.ElementParentNode;

extension DOM.Document {
    func getElementById(elementId: DOM.String) -> DOM.Element? {
        // Returns the first element within node’s descendants whose ID is elementId.
        guard let documentElement else {
            return nil
        }
        return DOM.getDescendants(element: documentElement).first { $0.id == elementId }
    }
}
