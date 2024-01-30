extension CSS {
    enum LineWidth: CustomStringConvertible {
        case thin
        case medium
        case thick

        init(value: String) {
            switch value {
            case "thin":
                self = .thin
            case "medium":
                self = .medium
            case "thick":
                self = .thick
            default:
                DIE("line-width: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .thin:
                "thin"
            case .medium:
                "medium"
            case .thick:
                "thick"
            }
        }
    }

    enum LengthOrPercentage: CustomStringConvertible, EnumStringInit {
        case length(Dimension)
        case percentage(Number)

        init(value: String) {
            if value.hasSuffix("%") {
                self = .percentage(.Number(Double(value.dropLast())!))
            } else if value.hasSuffix("px") {
                let number = Number(Double(value.dropLast(2))!)
                self = .length(Dimension(number: number,
                                         unit: Unit.Length(unit: "px")))
            } else {
                DIE("length-or-percentage: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case let .length(dimension):
                "\(dimension)"
            case let .percentage(number):
                "\(number)%"
            }
        }
    }

    static func parseLengthOrPercentage(context: ParseContext) -> Property<LengthOrPercentage> {
        let result: ParseResult<LengthOrPercentage> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        var value: PropertyValue<LengthOrPercentage> = .initial
        if declaration.count == 1 {
            switch declaration[0] {
            case let .token(.dimension(number: number, unit: unit)):
                value = .set(.length(Dimension(number: number, unit: Unit.Length(unit: unit))))
            default:
                FIXME("\(context.name) value: \(declaration) not implemented")
                value = .initial
            }
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }

    enum LengthOrPercentageOrAuto: CustomStringConvertible {
        case length(Dimension)
        case percentage(Number)
        case auto

        var description: String {
            switch self {
            case let .length(dimension):
                "\(dimension)"
            case let .percentage(number):
                "\(number)%"
            case .auto:
                "auto"
            }
        }
    }

    enum RectangularShorthand<T>: CustomStringConvertible {
        case one(T)
        case two(topBottom: T, leftRight: T)
        case three(top: T, leftRight: T, bottom: T)
        case four(top: T, right: T, bottom: T, left: T)

        var description: String {
            switch self {
            case let .one(value):
                "\(value)"
            case let .two(topBottom, leftRight):
                "\(topBottom) \(leftRight)"
            case let .three(top, leftRight, bottom):
                "\(top) \(leftRight) \(bottom)"
            case let .four(top, right, bottom, left):
                "\(top) \(right) \(bottom) \(left)"
            }
        }
    }

    static func parseColor(context: ParseContext) -> CSS.Property<CSS.Color> {
        let result: ParseResult<CSS.Color> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration

        let value: PropertyValue<Color> = if declaration.count == 1,
                                             case let .token(.ident(name)) = declaration[0]
        {
            .set(CSS.Color.named(CSS.Color.Named(string: name)))
        } else {
            .initial
        }

        return CSS.Property(
            name: context.name,
            value: value,
            important: declaration.important,
            caseSensitive: true
        )
    }
}

protocol EnumStringInit {
    init(value: String)
}

extension CSS {
    static func parseEnum<T: EnumStringInit>(context: ParseContext) -> Property<T> {
        let result: ParseResult<T> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<T>
        if declaration.count == 1, case let .token(.ident(name)) = declaration[0] {
            value = .set(.init(value: name))
        } else {
            FIXME("\(context.name): \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }
}

// Dimension
extension CSS {
    struct Dimension: CustomStringConvertible {
        var number: CSS.Number
        var unit: CSS.Unit.Length

        var description: String {
            "\(number)\(unit)"
        }
    }

    static func parseDimension(value: [CSS.ComponentValue]) -> PropertyValue<CSS.Number> {
        switch value.count {
        case 1:
            switch value[0] {
            case let .token(.dimension(number: number)):
                return .set(number.number)
            case .token(.ident("inherit")):
                return .inherit
            case .token(.ident("unset")):
                return .unset
            case .token(.ident("revert")):
                return .revert
            default:
                break
            }
        default:
            break
        }
        FIXME("dimension value: \(value) not implemented")
        return .initial
    }
}
