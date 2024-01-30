extension CSS {
    enum TextDecorationStyle: CustomStringConvertible, EnumStringInit {
        case solid
        case double
        case dotted
        case dashed
        case wavy

        init?(value: String) {
            switch value {
            case "solid":
                self = .solid
            case "double":
                self = .double
            case "dotted":
                self = .dotted
            case "dashed":
                self = .dashed
            case "wavy":
                self = .wavy
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .solid:
                "solid"
            case .double:
                "double"
            case .dotted:
                "dotted"
            case .dashed:
                "dashed"
            case .wavy:
                "wavy"
            }
        }
    }
}
