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
    }

    struct StyleProperty: CustomStringConvertible {
        var id: PropertyID
        var important: Bool = false
        var value: StyleValue?

        // FIXME: These two should be moved out of the struct to save space
        var initial: StyleValue
        var inherited = false

        init(id: PropertyID, important: Bool = false, initial: StyleValue, inherited: Bool = false) {
            self.id = id
            self.important = important
            self.initial = initial
            self.inherited = inherited
        }

        var description: String {
            if let value {
                return "\(id): \(value)\(important ? " !important" : "")"
            }
            return "\(id): <not set>\(important ? " !important" : "")"
        }

        func hasValue() -> Bool {
            value != nil
        }

        func display() -> Display {
            if case let .display(value) = value {
                return value
            }
            preconditionFailure()
        }

        func fontSize() -> FontSize {
            if case let .fontSize(value) = value {
                return value
            }
            preconditionFailure()
        }

        func lineHeight() -> LineHeight {
            if case let .lineHeight(value) = value {
                return value
            }
            preconditionFailure()
        }

        func margin() -> Margin {
            if case let .length(value) = value {
                return .length(value)
            }
            if case let .percentage(value) = value {
                return .percentage(value)
            }
            if case .auto = value {
                return .auto
            }
            preconditionFailure()
        }

        func padding() -> Padding {
            if case let .length(value) = value {
                return .length(value)
            }
            if case let .percentage(value) = value {
                return .percentage(value)
            }
            preconditionFailure()
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
