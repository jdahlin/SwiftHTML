
extension CSS {
    struct ParsedDeclaration {
        var tokens: [ComponentValue]
        var count: Int {
            tokens.count
        }

        var important = false

        subscript(index: Int) -> ComponentValue {
            tokens[index]
        }
    }

    struct ParseContext {
        var componentValues: [ComponentValue]

        func parseDeclaration() -> ParsedDeclaration {
            // parse important flag, from the end: !important
            var componentValues = componentValues
            var important = false
            if componentValues.count >= 2 {
                if case .token(.delim("!")) = componentValues[componentValues.count - 2],
                   case .token(.ident("important")) = componentValues[componentValues.count - 1]
                {
                    important = true
                    componentValues.removeLast(2)
                }
            }
            return ParsedDeclaration(tokens: componentValues, important: important)
        }
    }

    struct Property<T>: CustomStringConvertible {
        var value: PropertyValue<T>
        var important: Bool = false
        var caseSensitive: Bool = true

        init() {
            value = .initial
        }

        init(value: PropertyValue<T>, important: Bool = false, caseSensitive: Bool = true) {
            self.value = value
            self.important = important
            self.caseSensitive = caseSensitive
        }

        var description: String {
            if important {
                "\(value) !important"
            } else {
                "\(value)"
            }
        }
    }

    enum PropertyValue<T>: CustomStringConvertible {
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
        var backgroundColor: Property<CSS.Color> = .init()
        var borderColor: Property<CSS.Color> = .init()
        var borderStyle: Property<RectangularShorthand<CSS.BorderStyle>> = .init()
        var borderWidth: Property<RectangularShorthand<CSS.BorderWidth>> = .init()
        var display: Property<CSS.Display> = .init()
        var color: Property<CSS.Color> = .init()
        var margin: Property<RectangularShorthand<Margin>> = .init()
        var marginTop: Property<Margin> = .init()
        var marginBottom: Property<Margin> = .init()
        var marginLeft: Property<Margin> = .init()
        var marginRight: Property<Margin> = .init()
        var padding: Property<RectangularShorthand<Padding>> = .init()
        var paddingTop: Property<Padding> = .init()
        var paddingBottom: Property<Padding> = .init()
        var paddingLeft: Property<Padding> = .init()
        var paddingRight: Property<Padding> = .init()

        mutating func parseCSSValue(name: String, value valueWithWhitespace: [CSS.ComponentValue]) {
            let value: [CSS.ComponentValue] = valueWithWhitespace.filter {
                if case .token(.whitespace) = $0 {
                    return false
                }
                return true
            }

            let context = ParseContext(componentValues: value)
            switch name {
            case "background-color":
                backgroundColor = parseColor(context: context)
            case "border-color":
                borderColor = parseColor(context: context)
            case "border-style":
                borderStyle = parseBorderStyle(context: context)
            case "border-width":
                borderWidth = parseBorderWidth(context: context)
            case "color":
                color = parseColor(context: context)
            case "display":
                display = parseDisplay(context: context)
            case "margin":
                margin = parseMarginShorthand(context: context)
            case "margin-top":
                marginTop = parseMargin(context: context)
            case "margin-bottom":
                marginBottom = parseMargin(context: context)
            case "margin-left":
                marginLeft = parseMargin(context: context)
            case "margin-right":
                marginRight = parseMargin(context: context)
            case "padding":
                padding = parsePaddingShorthand(context: context)
            case "padding-top":
                paddingTop = parsePadding(context: context)
            case "padding-bottom":
                paddingBottom = parsePadding(context: context)
            case "padding-left":
                paddingLeft = parsePadding(context: context)
            case "padding-right":
                paddingRight = parsePadding(context: context)
            default:
                FIXME("\(name): \(value) not implemented")
            }
        }

        func toStringDict() -> [String: String] {
            var dict: [String: String] = [:]
            if case let .set(value) = backgroundColor.value {
                dict["background-color"] = "\(value)"
            }
            if case let .set(value) = borderColor.value {
                dict["border-color"] = "\(value)"
            }
            if case let .set(value) = borderStyle.value {
                dict["border-style"] = "\(value)"
            }
            if case let .set(value) = borderWidth.value {
                dict["border-width"] = "\(value)"
            }
            if case let .set(value) = color.value {
                dict["color"] = "\(value)"
            }
            if case let .set(value) = display.value {
                dict["display"] = "\(value)"
            }
            if case let .set(value) = margin.value {
                dict["margin"] = "\(value)"
            }
            if case let .set(value) = marginTop.value {
                dict["margin-top"] = "\(value)"
            }
            if case let .set(value) = marginBottom.value {
                dict["margin-bottom"] = "\(value)"
            }
            if case let .set(value) = marginLeft.value {
                dict["margin-left"] = "\(value)"
            }
            if case let .set(value) = marginRight.value {
                dict["margin-right"] = "\(value)"
            }
            if case let .set(value) = padding.value {
                dict["padding"] = "\(value)"
            }
            if case let .set(value) = paddingTop.value {
                dict["padding-top"] = "\(value)"
            }
            if case let .set(value) = paddingBottom.value {
                dict["padding-bottom"] = "\(value)"
            }
            if case let .set(value) = paddingLeft.value {
                dict["padding-left"] = "\(value)"
            }
            if case let .set(value) = paddingRight.value {
                dict["padding-right"] = "\(value)"
            }
            return dict
        }
    }
}
