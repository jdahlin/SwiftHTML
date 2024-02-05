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

        func toPx() -> CSS.Pixels {
            // FIXME: Completely ad-hoc
            let value = switch self {
            case .xxSmall: 9
            case .xSmall: 10
            case .small: 13
            case .medium: 16
            case .large: 18
            case .xLarge: 24
            case .xxLarge: 32
            case .xxxLarge: 48
            }
            return CSS.Pixels(value)
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
                let number = Double(value.dropLast(2))!
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

        func isAbsolute() -> Bool {
            switch self {
            case .absolute: true
            default: false
            }
        }

        func length() -> Length {
            switch self {
            case let .length(length):
                length
            default:
                preconditionFailure()
            }
        }

        func absoluteLengthToPx() -> Pixels {
            switch self {
            case let .absolute(absoluteLength):
                absoluteLength.toPx()
            default:
                preconditionFailure()
            }
        }
    }
}

extension CSS.StyleProperties {
    func parseFontSize(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        var value: CSS.StyleValue? = nil
        if declaration.count == 1, case let .token(.ident(ident)) = declaration[0] {
            switch ident {
            case "xx-small":
                value = .fontSize(.absolute(.xxSmall))
            case "x-small":
                value = .fontSize(.absolute(.xSmall))
            case "small":
                value = .fontSize(.absolute(.small))
            case "medium":
                value = .fontSize(.absolute(.medium))
            case "large":
                value = .fontSize(.absolute(.large))
            case "x-large":
                value = .fontSize(.absolute(.xLarge))
            case "xx-large":
                value = .fontSize(.absolute(.xxLarge))
            case "xxx-large":
                value = .fontSize(.absolute(.xxxLarge))
            case "larger":
                value = .fontSize(.relative(.larger))
            case "smaller":
                value = .fontSize(.relative(.smaller))
            case "math":
                value = .fontSize(.math)
            default:
                if let keyword = parseGlobalKeywords(ident) {
                    value = keyword
                } else if ident.hasSuffix("%") {
                    value = .fontSize(.percent(.Number(Double(ident.dropLast())!)))
                } else if ident.hasSuffix("px") {
                    let number = Double(ident.dropLast(2))!
                    value = .fontSize(.length(CSS.Length(number: number, unit: "px")))
                }
            }
        }
        return value
    }
}

extension CSS.FontSize: Equatable {}

extension CSS.FontSize: CSSPropertyValue {
    typealias T = CSS.FontSize

    init?(_ styleValue: CSS.StyleValue?) {
        switch styleValue {
        case let .fontSize(fontSize):
            self = fontSize
        case nil:
            return nil
        default:
            FIXME("Unable to convert font-size from StyleValue: \(styleValue!)")
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        .fontSize(self)
    }
}
