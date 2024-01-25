extension HTML {
    struct StackOfOpenElements {
        var stack: [DOM.Element] = []

        var bottommost: DOM.Element? {
            stack.last
        }

        mutating func push(element: DOM.Element) {
            stack.append(element)
        }

        @discardableResult mutating func pop() -> DOM.Element? {
            let element = stack.removeLast()
            if let instance = element as? StackOfOpenElementsNotification {
                instance.wasRemoved()
            }
            return element
        }

        mutating func removePointedBy(element: DOM.Element) {
            guard let index = stack.firstIndex(of: element) else {
                return
            }
            stack.remove(at: index)
        }

        func hasElementInScope(withTagName: String) -> Bool {
            stack.contains { $0.localName == withTagName }
        }

        func hasElementsInScope(withTagNames: [String]) -> Bool {
            stack.contains { withTagNames.contains($0.tagName) }
        }
    }
}
