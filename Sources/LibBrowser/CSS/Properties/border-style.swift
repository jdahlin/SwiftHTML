extension CSS {
    enum BorderStyle {
        case none
        case hidden
        case dotted
        case dashed
        case solid
        case double
        case groove
        case ridge
        case inset
        case outset

        init(value: String) {
            switch value {
            case "none":
                self = .none
            case "hidden":
                self = .hidden
            case "dotted":
                self = .dotted
            case "dashed":
                self = .dashed
            case "solid":
                self = .solid
            case "double":
                self = .double
            case "groove":
                self = .groove
            case "ridge":
                self = .ridge
            case "inset":
                self = .inset
            case "outset":
                self = .outset
            default:
                DIE("border-style: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .none:
                "none"
            case .hidden:
                "hidden"
            case .dotted:
                "dotted"
            case .dashed:
                "dashed"
            case .solid:
                "solid"
            case .double:
                "double"
            case .groove:
                "groove"
            case .ridge:
                "ridge"
            case .inset:
                "inset"
            case .outset:
                "outset"
            }
        }
    }

    static func parseBorderStyle(value: [CSS.ComponentValue]) -> Property<RectangularShorthand<BorderStyle>> {
        func parse(value: CSS.ComponentValue) -> BorderStyle {
            switch value {
            case let .token(.ident(ident)):
                BorderStyle(value: ident)
            default:
                DIE("border-style value: \(value) not implemented")
            }
        }
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("border-style value: \(value) not implemented")
        }
        return .initial
    }
}
