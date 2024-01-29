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

    enum LengthOrPercentage: CustomStringConvertible {
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
        let declaration = context.parseDeclaration()
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

// Dimension
extension CSS {
    struct Dimension: CustomStringConvertible {
        var number: CSS.Number
        var unit: CSS.Unit.Length

        var description: String {
            "\(number)\(unit)"
        }
    }

    static func parseDimension(value: [CSS.ComponentValue]) -> CSS.Number? {
        switch value.count {
        case 1:
            switch value[0] {
            case let .token(.dimension(number: number)):
                return number.number
            default:
                break
            }
        default:
            break
        }
        FIXME("dimension value: \(value) not implemented")
        return nil
    }
}
