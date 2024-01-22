struct StackOfOpenElements {
    var stack: [Element] = []

    public var bottommost: Element? {
        stack.first
    }

    public mutating func push(element: Element) {
        stack.append(element)
    }

    @discardableResult public mutating func pop() -> Element? {
        stack.removeLast()
    }

    public mutating func removePointedBy(element: Element) {
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
