// 2.5. Font size: the font-size property
// https://drafts.csswg.org/css-fonts/#font-size-prop
extension CSS {
    enum FontSizeAbsolute: String, EnumStringInit {
        case xxSmall
        case xSmall
        case small
        case medium
        case large
        case xLarge
        case xxLarge
        case xxxLarge

        init(value: String) {
            switch value {
            case "xx-small":
                self = .xxSmall
            case "x-small":
                self = .xSmall
            case "small":
                self = .small
            case "medium":
                self = .medium
            case "large":
                self = .large
            case "x-large":
                self = .xLarge
            case "xx-large":
                self = .xxLarge
            case "xxx-large":
                self = .xxxLarge
            default:
                DIE("font-size: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .xxSmall:
                "xx-small"
            case .xSmall:
                "x-small"
            case .small:
                "small"
            case .medium:
                "medium"
            case .large:
                "large"
            case .xLarge:
                "x-large"
            case .xxLarge:
                "xx-large"
            case .xxxLarge:
                "xxx-large"
            }
        }
    }

    enum FontSizeRelative: String, EnumStringInit {
        case larger
        case smaller

        init(value: String) {
            switch value {
            case "larger":
                self = .larger
            case "smaller":
                self = .smaller
            default:
                DIE("font-size: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .larger:
                "larger"
            case .smaller:
                "smaller"
            }
        }
    }

    enum FontSize: CustomStringConvertible, EnumStringInit {
        case absolute(FontSizeAbsolute)
        case relative(FontSizeRelative)
        case length(Length)
        case percent(Number)
        case math

        init(value: String) {
            if value.hasSuffix("%") {
                self = .percent(.Number(Double(value.dropLast())!))
            } else if value.hasSuffix("px") {
                let number = Number(Double(value.dropLast(2))!)
                self = .length(Length(number: number, unit: "px"))
            } else if value == "math" {
                self = .math
            } else {
                if let absolute = FontSizeAbsolute(rawValue: value) {
                    self = .absolute(absolute)
                } else if let relative = FontSizeRelative(rawValue: value) {
                    self = .relative(relative)
                } else {
                    DIE("font-size: \(value) not implemented")
                }
            }
        }

        var description: String {
            switch self {
            case let .absolute(value):
                "\(value)"
            case let .relative(value):
                "\(value)"
            case let .length(dimension):
                "\(dimension)"
            case let .percent(number):
                "\(number)%"
            case .math:
                "math"
            }
        }
    }

    static func parseFontSize(context: ParseContext) -> Property<FontSize> {
        let result: ParseResult<FontSize> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        var value: PropertyValue<FontSize> = .initial
        if declaration.count == 1, case let .token(.ident(ident)) = declaration[0] {
            switch ident {
            case "xx-small":
                value = .set(.absolute(.xxSmall))
            case "x-small":
                value = .set(.absolute(.xSmall))
            case "small":
                value = .set(.absolute(.small))
            case "medium":
                value = .set(.absolute(.medium))
            case "large":
                value = .set(.absolute(.large))
            case "x-large":
                value = .set(.absolute(.xLarge))
            case "xx-large":
                value = .set(.absolute(.xxLarge))
            case "xxx-large":
                value = .set(.absolute(.xxxLarge))
            case "larger":
                value = .set(.relative(.larger))
            case "smaller":
                value = .set(.relative(.smaller))
            case "math":
                value = .set(.math)
            default:
                if ident.hasSuffix("%") {
                    value = .set(.percent(.Number(Double(ident.dropLast())!)))
                } else if ident.hasSuffix("px") {
                    let number = Number(Double(ident.dropLast(2))!)
                    value = .set(.length(Length(number: number, unit: "px")))
                } else {
                    DIE("\(context.name): \(ident) not implemented")
                }
            }
        }

        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }
}
