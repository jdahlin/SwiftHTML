// https://drafts.csswg.org/css2/#propdef-vertical-align
extension CSS {
    enum VerticalAlign: CustomStringConvertible, EnumStringInit {
        case baseline
        case sub
        case `super`
        case top
        case textTop
        case middle
        case bottom
        case textBottom
        case percent(Number)
        case length(Number)

        init(value: String) {
            switch value {
            case "baseline":
                self = .baseline
            case "sub":
                self = .sub
            case "super":
                self = .super
            case "top":
                self = .top
            case "text-top":
                self = .textTop
            case "middle":
                self = .middle
            case "bottom":
                self = .bottom
            case "text-bottom":
                self = .textBottom
            default:
                if value.hasSuffix("%") {
                    self = .percent(.Number(Double(value.dropLast())!))
                } else if value.hasSuffix("px") {
                    self = .length(.Number(Double(value.dropLast(2))!))
                } else {
                    DIE("vertical-align: \(value) not implemented")
                }
            }
        }

        var description: String {
            switch self {
            case .baseline:
                "baseline"
            case .sub:
                "sub"
            case .super:
                "super"
            case .top:
                "top"
            case .textTop:
                "text-top"
            case .middle:
                "middle"
            case .bottom:
                "bottom"
            case .textBottom:
                "text-bottom"
            case let .percent(value):
                "\(value)%"
            case let .length(value):
                "\(value)px"
            }
        }
    }

    static func parseVerticalAlign(context: ParseContext) -> Property<VerticalAlign> {
        let declaration = context.parseDeclaration()
        var value: PropertyValue<VerticalAlign> = .initial
        if declaration.count == 1 {
            switch declaration[0] {
            case let .token(.ident(ident)):
                value = .set(VerticalAlign(value: ident))
            case let .token(.percentage(number)):
                value = .set(.percent(number))
            default:
                break
            }
        }
        if case .initial = value {
            DIE("vertical-align value: \(declaration) not implemented")
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }
}
