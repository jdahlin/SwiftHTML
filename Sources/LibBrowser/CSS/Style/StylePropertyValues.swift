
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
        case .inherit, .initial, .revert, .unset:
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

extension CSS {
    struct PropertyValues: CustomStringConvertible {
        var description: String {
            let values = toStringDict().map { "\($0): \($1)" }.joined(separator: "; ")
            return "PropertyValues(\(values))"
        }

        var appearance: Property<Appearance> = .init()
        var backgroundColor: Property<Color> = .init()
        var borderColor: Property<Color> = .init()
        var borderCollapse: Property<BorderCollapse> = .init()
        var borderStyle: Property<RectangularShorthand<BorderStyle>> = .init()
        var borderWidth: Property<RectangularShorthand<BorderWidth>> = .init()
        var bottom: Property<LengthOrPercentage> = .init()
        var boxSizing: Property<BoxSizing> = .init()
        var color: Property<Color> = .init()
        var direction: Property<Direction> = .init()
        var display: Property<Display> = .init()
        var float: Property<FloatValue> = .init()
        var fontSize: Property<FontSize> = .init()
        var fontStyle: Property<FontStyle> = .init()
        var fontWeight: Property<FontWeight> = .init()
        var height: Property<Height> = .init()
        var justifySelf: Property<JustifySelf> = .init()
        var left: Property<LengthOrPercentage> = .init()
        var listStyle: Property<ListStyle> = .init()
        var listStyleType: Property<ListStyleType> = .init()
        var margin: Property<RectangularShorthand<Margin>> = .init()
        var marginBlockEnd: Property<Margin> = .init()
        var marginBlockStart: Property<Margin> = .init()
        var marginBottom: Property<Margin> = .init()
        var marginInlineEnd: Property<Margin> = .init()
        var marginInlineStart: Property<Margin> = .init()
        var marginLeft: Property<Margin> = .init()
        var marginRight: Property<Margin> = .init()
        var marginTop: Property<Margin> = .init()
        var objectFit: Property<ObjectFit> = .init()
        var outlineStyle: Property<OutlineStyle> = .init()
        var overflow: Property<Overflow> = .init()
        var overflowBlock: Property<Overflow> = .init()
        var overflowInline: Property<Overflow> = .init()
        var overflowX: Property<Overflow> = .init()
        var overflowY: Property<Overflow> = .init()
        var padding: Property<RectangularShorthand<Padding>> = .init()
        var paddingBlockEnd: Property<Padding> = .init()
        var paddingBlockStart: Property<Padding> = .init()
        var paddingBottom: Property<Padding> = .init()
        var paddingInlineEnd: Property<Padding> = .init()
        var paddingInlineStart: Property<Padding> = .init()
        var paddingLeft: Property<Padding> = .init()
        var paddingRight: Property<Padding> = .init()
        var paddingTop: Property<Padding> = .init()
        var position: Property<Position> = .init()
        var right: Property<LengthOrPercentage> = .init()
        var textAlign: Property<TextAlign> = .init()
        var textDecorationLine: Property<TextDecorationLine> = .init()
        var textDecorationStyle: Property<TextDecorationStyle> = .init()
        var top: Property<LengthOrPercentage> = .init()
        var verticalAlign: Property<VerticalAlign> = .init()
        var unicodeBidi: Property<UnicodeBidi> = .init()
        var visibility: Property<Visibility> = .init()
        var whiteSpace: Property<Whitespace> = .init()
        var width: Property<Width> = .init()

        mutating func parseCSSValue(name: String, value valueWithWhitespace: [CSS.ComponentValue]) {
            let values: [CSS.ComponentValue] = valueWithWhitespace.filter {
                if case .token(.whitespace) = $0 {
                    return false
                }
                return true
            }
            let context = ParseContext(componentValues: values, name: name)
            switch name {
            case "appearance":
                appearance = parseEnum(context: context)
            case "background-color":
                backgroundColor = parseColor(context: context)
            case "border-color":
                borderColor = parseColor(context: context)
            case "border-collapse":
                borderCollapse = parseEnum(context: context)
            case "border-style":
                borderStyle = parseBorderStyle(context: context)
            case "border-width":
                borderWidth = parseBorderWidth(context: context)
            case "bottom":
                bottom = parseLengthOrPercentage(context: context)
            case "box-sizing":
                boxSizing = parseEnum(context: context)
            case "color":
                color = parseColor(context: context)
            case "direction":
                direction = parseEnum(context: context)
            case "display":
                display = parseEnum(context: context)
            case "float":
                float = parseEnum(context: context)
            case "font-size":
                fontSize = parseFontSize(context: context)
            case "font-style":
                fontStyle = parseEnum(context: context)
            case "font-weight":
                fontWeight = parseEnum(context: context)
            case "justify-self":
                justifySelf = parseEnum(context: context)
            case "height":
                height = parseHeight(context: context)
            case "left":
                left = parseLengthOrPercentage(context: context)
            case "list-style":
                listStyle = parseListStyle(context: context)
            case "list-style-type":
                listStyleType = parseListStyleType(context: context)
            case "margin":
                margin = parseMarginShorthand(context: context)
            case "margin-top":
                marginTop = parseMargin(context: context)
            case "margin-block-end":
                marginBlockEnd = parseMargin(context: context)
            case "margin-block-start":
                marginBlockStart = parseMargin(context: context)
            case "margin-bottom":
                marginBottom = parseMargin(context: context)
            case "margin-inline-end":
                marginInlineEnd = parseMargin(context: context)
            case "margin-inline-start":
                marginInlineStart = parseMargin(context: context)
            case "margin-left":
                marginLeft = parseMargin(context: context)
            case "margin-right":
                marginRight = parseMargin(context: context)
            case "object-fit":
                objectFit = parseEnum(context: context)
            case "outline-style":
                outlineStyle = parseEnum(context: context)
            case "overflow-block":
                overflowBlock = parseEnum(context: context)
            case "overflow-inline":
                overflowInline = parseEnum(context: context)
            case "overflow":
                overflow = parseEnum(context: context)
            case "overflow-x":
                overflowInline = parseEnum(context: context)
            case "overflow-y":
                overflowInline = parseEnum(context: context)
            case "padding":
                padding = parsePaddingShorthand(context: context)
            case "padding-block-end":
                paddingBlockEnd = parseLengthOrPercentage(context: context)
            case "padding-block-start":
                paddingBlockStart = parseLengthOrPercentage(context: context)
            case "padding-top":
                paddingTop = parsePadding(context: context)
            case "padding-bottom":
                paddingBottom = parsePadding(context: context)
            case "padding-inline-end":
                paddingInlineEnd = parseLengthOrPercentage(context: context)
            case "padding-inline-start":
                paddingInlineStart = parseLengthOrPercentage(context: context)
            case "padding-left":
                paddingLeft = parsePadding(context: context)
            case "padding-right":
                paddingRight = parsePadding(context: context)
            case "position":
                position = parseEnum(context: context)
            case "right":
                right = parseLengthOrPercentage(context: context)
            case "text-align":
                textAlign = parseEnum(context: context)
            case "text-decoration-line":
                textDecorationLine = parseEnum(context: context)
            case "text-decoration-style":
                textDecorationStyle = parseEnum(context: context)
            case "top":
                top = parseLengthOrPercentage(context: context)
            case "unicode-bidi":
                unicodeBidi = parseEnum(context: context)
            case "width":
                width = parseWidth(context: context)
            case "white-space":
                whiteSpace = parseEnum(context: context)
            case "vertical-align":
                verticalAlign = parseVerticalAlign(context: context)
            case "visibility":
                visibility = parseEnum(context: context)
            default:
                FIXME("\(name): \(values) not implemented")
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
            for (name, property: _, value) in fetchSetProperties() {
                dict[name] = "\(value)"
            }
            return dict
        }
    }
}
