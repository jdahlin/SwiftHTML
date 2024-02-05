extension CSS {
    enum PropertyID {
        case all
        case backgroundColor
        case color
        case display
        case fontSize
        case insetBlockEnd
        case insetBlockStart
        case insetInlineEnd
        case insetInlineStart
        case lineHeight
        case margin
        case marginTop
        case marginRight
        case marginBottom
        case marginLeft
        case padding
        case paddingTop
        case paddingRight
        case paddingBottom
        case paddingLeft
        case top
        case right
        case bottom
        case left
        case width
        case height
    }

    @propertyWrapper
    struct StylePropertyWrapper<Value: CSSPropertyValue> {
        private var value: StyleValue?
        private(set) var projectedValue: StyleProperty
        var wrappedValue: Value? {
            get {
                if let styleValue = value,
                   let value = Value(styleValue)
                {
                    return value
                }
                return nil
            }
            set {
                value = newValue?.styleValue()
            }
        }

        init(_ id: PropertyID, inherited: Bool = false) {
            projectedValue = StyleProperty(id: id, inherited: inherited)
        }
    }

    struct StyleProperty: CustomStringConvertible {
        let id: PropertyID
        var important: Bool = false
        var value: StyleValue?
        static var initialValues: [PropertyID: StyleValue] = [:]
        static var inheritedValues: [PropertyID: Bool] = [:]

        init(id: PropertyID, important: Bool = false, value: StyleValue? = nil, inherited _: Bool = false) {
            self.id = id
            self.important = important
            self.value = value
            // if StyleProperty.initialValues.keys.contains(id) {
            //     assert(StyleProperty.initialValues[id] == initial)
            // } else {
            //     StyleProperty.initialValues[id] = initial
            // }
            // if StyleProperty.inheritedValues.keys.contains(id) {
            //     assert(StyleProperty.inheritedValues[id] == inherited)
            // } else {
            //     StyleProperty.inheritedValues[id] = inherited
            // }
        }

        var initial: StyleValue { StyleProperty.initialValues[id]! }
        var inherited: Bool { StyleProperty.inheritedValues[id]! }

        var description: String {
            if let value {
                return "\(id): \(value)\(important ? " !important" : "")"
            }
            return "\(id): <not set>\(important ? " !important" : "")"
        }

        func hasValue() -> Bool {
            value != nil
        }

        func isRevert() -> Bool {
            // https://drafts.csswg.org/css-cascade/#revert
            // The revert keyword is a shorthand for the initial value of all
            // properties, i.e., it is equivalent to setting all properties to
            // their initial value.
            if case .revert = value {
                return true
            }
            return false
        }
    }

    struct Box<T> {
        var top: T
        var right: T
        var bottom: T
        var left: T
    }

    func layout(style _: StyleProperties) {}
}
