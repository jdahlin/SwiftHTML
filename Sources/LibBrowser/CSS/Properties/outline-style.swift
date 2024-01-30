extension CSS {
    enum OutlineStyle: CustomStringConvertible, EnumStringInit {
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

        init?(value: String) {
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
                return nil
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
}
