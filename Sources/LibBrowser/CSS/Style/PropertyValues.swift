
extension CSS {
    struct ParsedDeclaration {
        var componentValues: [ComponentValue]
        var count: Int {
            componentValues.count
        }

        var important = false

        subscript(index: Int) -> ComponentValue {
            componentValues[index]
        }
    }

    struct ParseContext {
        var componentValues: [ComponentValue]
        var name: String

        func parseDeclaration() -> ParsedDeclaration {
            // parse important flag, from the end: !important
            let result = CSS.parseImportant(componentValues: componentValues)
            return ParsedDeclaration(
                componentValues: result.valuesWithoutImportant,
                important: result.important
            )
        }
    }

    struct Property<T>: CustomStringConvertible {
        var name: String?
        var value: PropertyValue<T>
        var important: Bool = false
        var caseSensitive: Bool = true

        init() {
            // https://drafts.csswg.org/css-cascade/#initial-values
            // Each property has an initial value, defined in the property’s
            // definition table. If the property is not an inherited property,
            // and the cascade does not result in a value, then the specified
            // value of the property is its initial value.
            value = .initial
        }

        init(name: String, value: PropertyValue<T>, important: Bool = false, caseSensitive: Bool = true) {
            self.name = name
            self.value = value
            self.important = important
            self.caseSensitive = caseSensitive
        }

        var description: String {
            if important {
                "Property(\(name!): \(value) !important)"
            } else {
                "Property(\(name!): \(value))"
            }
        }
    }

    enum PropertyValue<T>: CustomStringConvertible {
        case set(T)
        // https://www.w3.org/TR/css-values-4/#common-keywords
        // https://drafts.csswg.org/css-cascade/#defaulting-keywords
        case inherited
        case initial
        case revert
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
            case .unset:
                "unset"
            }
        }
    }

    struct PropertyValues: CustomStringConvertible {
        var description: String {
            let values = toStringDict().map { "\($0): \($1)" }.joined(separator: "; ")
            return "PropertyValues(\(values))"
        }

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

            let context = ParseContext(componentValues: value, name: name)
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

        func fetchSetProperties() -> [(name: String, property: AnySetProperty, value: Any)] {
            Mirror(reflecting: self)
                .children
                .compactMap { child in
                    guard let property = child.value as? AnySetProperty else { return nil }
                    return (child.label ?? "unknown", property, property.typeErasedValue.asAny)
                }
                .filter(\.property.isSet)
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

protocol AnyPropertyValue {
    var asAny: Any { get }
}

protocol AnySetProperty {
    var isSet: Bool { get }
    var propertyName: String? { get }
    var typeErasedValue: AnyPropertyValue { get }
}

extension CSS.PropertyValue: AnyPropertyValue {
    var asAny: Any {
        switch self {
        case let .set(value):
            value
        case .inherited, .initial, .revert, .unset:
            self
        }
    }
}

extension CSS.Property: AnySetProperty {
    var isSet: Bool {
        if case .set = value {
            true
        } else {
            false
        }
    }

    var propertyName: String? { name }
    var typeErasedValue: AnyPropertyValue {
        value
    }
}
