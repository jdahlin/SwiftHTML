extension CSS {
    enum StyleValue: CustomStringConvertible {
        case inherit
        case initial
        case revert
        case unset
        case appearance(Appearance)
        case display(Display)
        case fontSize(FontSize)
        case lineHeight(LineHeight)
        case margin(Margin)
        case padding(Padding)

        var description: String {
            switch self {
            case .inherit:
                "inherit"
            case .initial:
                "initial"
            case .revert:
                "revert"
            case .unset:
                "unset"
            case let .appearance(value):
                "appearance(\(value))"
            case let .display(value):
                "display(\(value))"
            case let .fontSize(value):
                "fontSize(\(value))"
            case let .lineHeight(value):
                "lineHeight(\(value))"
            case let .margin(value):
                "margin(\(value)"
            case let .padding(value):
                "padding(\(value)"
            }
        }
    }

    struct StyleProperty {
        var name: String
        var important: Bool = false
        var value: StyleValue

        init(name: String, important: Bool = false, value: StyleValue) {
            self.name = name
            self.important = important
            self.value = value
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
