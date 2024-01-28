
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
                ""
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
        var marginTop: Property<Margin> = .initial
        var marginBottom: Property<Margin> = .initial
        var marginLeft: Property<Margin> = .initial
        var marginRight: Property<Margin> = .initial
        var padding: Property<RectangularShorthand<Padding>> = .initial
        var paddingTop: Property<Padding> = .initial
        var paddingBottom: Property<Padding> = .initial
        var paddingLeft: Property<Padding> = .initial
        var paddingRight: Property<Padding> = .initial

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
                margin = parseMarginShorthand(value: value)
            case "margin-top":
                marginTop = parseMargin(value: value)
            case "margin-bottom":
                marginBottom = parseMargin(value: value)
            case "margin-left":
                marginLeft = parseMargin(value: value)
            case "margin-right":
                marginRight = parseMargin(value: value)
            case "padding":
                padding = parsePaddingShorthand(value: value)
            case "padding-top":
                paddingTop = parsePadding(value: value)
            case "padding-bottom":
                paddingBottom = parsePadding(value: value)
            case "padding-left":
                paddingLeft = parsePadding(value: value)
            case "padding-right":
                paddingRight = parsePadding(value: value)
            default:
                FIXME("\(name): \(value) not implemented")
            }
        }
    }
}
