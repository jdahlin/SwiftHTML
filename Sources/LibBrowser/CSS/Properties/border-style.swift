#if false
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

        static func parseBorderStyle(value: ComponentValue) -> BorderStyle {
            switch value {
            case let .token(.ident(ident)):
                BorderStyle(value: ident)
            default:
                DIE("border-style value: \(value) not implemented")
            }
        }

        static func parseBorderStyle(context: ParseContext) -> Property<RectangularShorthand<BorderStyle>> {
            let result: ParseResult<RectangularShorthand<BorderStyle>> = context.parseGlobal()
            if let property = result.property {
                return property
            }
            let declaration = result.declaration
            let value: PropertyValue<RectangularShorthand<BorderStyle>>

            switch declaration.count {
            case 1:
                value = .set(.one(parseBorderStyle(value: declaration[0])))
            case 2:
                value = .set(.two(
                    topBottom: parseBorderStyle(value: declaration[0]),
                    leftRight: parseBorderStyle(value: declaration[1])
                ))
            case 3:
                value = .set(.three(
                    top: parseBorderStyle(value: declaration[0]),
                    leftRight: parseBorderStyle(value: declaration[1]),
                    bottom: parseBorderStyle(value: declaration[2])
                ))
            case 4:
                value = .set(.four(
                    top: parseBorderStyle(value: declaration[0]),
                    right: parseBorderStyle(value: declaration[1]),
                    bottom: parseBorderStyle(value: declaration[2]),
                    left: parseBorderStyle(value: declaration[3])
                ))
            default:
                value = .initial
                FIXME("\(context.name) value: \(declaration) not implemented")
            }

            return CSS.Property(name: context.name, value: value, important: declaration.important)
        }
    }
#endif
