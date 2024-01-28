
extension CSS {
    enum Property<T>: CustomStringConvertible {
        case set(T)
        case inherited
        case initial
        case revert
        case revertLayer
        case unset

        var description: String {
            switch self {
            case let .set(value):
                "\(value)"
            case .inherited:
                "inherited"
            case .initial:
                "initial"
            case .revert:
                "revert"
            case .revertLayer:
                "revertLayer"
            case .unset:
                "unset"
            }
        }
    }

    struct PropertyValues {
        var backgroundColor: Property<CSS.Color> = .initial
        var borderStyle: Property<RectangularShorthand<CSS.BorderStyle>> = .initial
        var borderWidth: Property<RectangularShorthand<CSS.BorderWidth>> = .initial
        var display: Property<CSS.Display> = .initial
        var color: Property<CSS.Color> = .initial
        var margin: Property<RectangularShorthand<Margin>> = .initial
        var padding: Property<RectangularShorthand<Padding>> = .initial

        mutating func parseCSSValue(name: String, value valueWithWhitespace: [CSS.ComponentValue]) {
            let value: [CSS.ComponentValue] = valueWithWhitespace.filter {
                if case .token(.whitespace) = $0 {
                    return false
                }
                return true
            }
            switch name {
            case "background-color":
                backgroundColor = parseColor(value: value)
            case "border-style":
                borderStyle = parseBorderStyle(value: value)
            case "border-width":
                borderWidth = parseBorderWidth(value: value)
            case "color":
                color = parseColor(value: value)
            case "display":
                display = parseDisplay(value: value)
            case "margin":
                margin = parseMargin(value: value)
            case "padding":
                padding = parsePadding(value: value)
            default:
                FIXME("\(name): \(value) not implemented")
            }
        }
    }
}
