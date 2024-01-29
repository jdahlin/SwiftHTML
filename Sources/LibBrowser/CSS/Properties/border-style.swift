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

    static func parseBorderStyle(context: ParseContext) -> Property<RectangularShorthand<BorderStyle>> {
        let declaration = context.parseDeclaration()
        func parse(value: ComponentValue) -> BorderStyle {
            switch value {
            case let .token(.ident(ident)):
                BorderStyle(value: ident)
            default:
                DIE("border-style value: \(value) not implemented")
            }
        }
        var value: PropertyValue<RectangularShorthand<BorderStyle>>
        switch declaration.count {
        case 1:
            value = .set(.one(parse(value: declaration[0])))
        case 2:
            value = .set(.two(
                topBottom: parse(value: declaration[0]),
                leftRight: parse(value: declaration[1])
            ))
        case 3:
            value = .set(.three(
                top: parse(value: declaration[0]),
                leftRight: parse(value: declaration[1]),
                bottom: parse(value: declaration[2])
            ))
        case 4:
            value = .set(.four(
                top: parse(value: declaration[0]),
                right: parse(value: declaration[1]),
                bottom: parse(value: declaration[2]),
                left: parse(value: declaration[3])
            ))
        default:
            value = .initial
            FIXME("border-style value: \(declaration) not implemented")
        }

        return CSS.Property(value: value, important: declaration.important)
    }
}
