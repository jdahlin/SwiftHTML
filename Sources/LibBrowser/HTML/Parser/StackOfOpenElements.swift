extension HTML {
    struct StackOfOpenElements {
        var stack: [DOM.Element] = []

        public var bottommost: DOM.Element? {
            stack.last
        }

        public mutating func push(element: DOM.Element) {
            stack.append(element)
        }

        @discardableResult public mutating func pop() -> DOM.Element? {
            let element = stack.removeLast()
            if let instance = element as? StackOfOpenElementsNotification {
                instance.wasRemoved()
            }
            return element
        }

        public mutating func removePointedBy(element: DOM.Element) {
            guard let index = stack.firstIndex(of: element) else {
                return
            }
            stack.remove(at: index)
        }

        public func hasElementInScope(withTagName: String) -> Bool {
            stack.contains { $0.localName == withTagName }
        }

        public func hasElementsInScope(withTagNames: [String]) -> Bool {
            stack.contains { withTagNames.contains($0.tagName) }
        }
    }
}
