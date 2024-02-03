extension CSS {
    struct StyleProperty: CustomStringConvertible {
        var name: String
        var important: Bool = false
        var value: StyleValue?
        var initial: StyleValue
        var inherited = false

        init(name: String, important: Bool = false, initial: StyleValue, inherited: Bool = false) {
            self.name = name
            self.important = important
            self.initial = initial
            self.inherited = inherited
        }

        var description: String {
            if let value {
                return "\(name): \(value)\(important ? " !important" : "")"
            }
            return "\(name): <not set>\(important ? " !important" : "")"
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

        func margin() -> Margin {
            if case let .margin(value) = value {
                return value
            }
            preconditionFailure()
        }

        func padding() -> Padding {
            if case let .padding(value) = value {
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
