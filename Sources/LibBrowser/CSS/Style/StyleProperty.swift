extension CSS {
    enum PropertyID {
        case all
        case backgroundColor
        case borderTopColor
        case borderTopStyle
        case borderTopWidth
        case borderRightColor
        case borderRightStyle
        case borderRightWidth
        case borderBottomColor
        case borderBottomStyle
        case borderBottomWidth
        case borderLeftColor
        case borderLeftStyle
        case borderLeftWidth
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
        case outlineColor
        case outlineStyle
        case outlineWidth
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
        private(set) var projectedValue: StyleProperty
        var wrappedValue: Value? {
            get {
                let value = switch projectedValue.value {
                case .unresolved: projectedValue.initial
                default: projectedValue.value
                }
                return Value(value)
            }
            set {
                projectedValue.value = newValue?.styleValue() ?? .unresolved
            }
        }

        init(_ id: PropertyID, initial: StyleValue, inherited: Bool = false) {
            projectedValue = StyleProperty(id: id, initial: initial, inherited: inherited)
        }
    }

    class StyleProperty: CustomStringConvertible {
        let id: PropertyID
        var important: Bool = false
        var value: StyleValue = .unresolved
        static var initialValues: [PropertyID: StyleValue] = [:]
        static var inheritedValues: [PropertyID: Bool] = [:]

        init(id: PropertyID,
             important: Bool = false,
             initial: StyleValue? = nil,
             inherited: Bool = false)
        {
            self.id = id
            self.important = important
            if StyleProperty.initialValues.keys.contains(id) {
                assert(StyleProperty.initialValues[id] == initial)
            } else {
                StyleProperty.initialValues[id] = initial
            }
            if StyleProperty.inheritedValues.keys.contains(id) {
                assert(StyleProperty.inheritedValues[id] == inherited)
            } else {
                StyleProperty.inheritedValues[id] = inherited
            }
        }

        var initial: StyleValue { StyleProperty.initialValues[id]! }
        var inherited: Bool { StyleProperty.inheritedValues[id]! }

        var description: String {
            "\(id): \(value)\(important ? " !important" : "")"
        }

        func resolved() -> Bool {
            if case .unresolved = value {
                return false
            }
            return true
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

protocol AnyPropertyValue {
    var id: CSS.PropertyID { get }
    var valueAsAny: Any? { get }
    var property: CSS.StyleProperty { get }
}

extension CSS.StylePropertyWrapper: AnyPropertyValue {
    var valueAsAny: Any? {
        switch projectedValue.value {
        case .unresolved: nil
        default: projectedValue.value
        } as Any?
    }

    var id: CSS.PropertyID { projectedValue.id }
    var property: CSS.StyleProperty { projectedValue }
}
