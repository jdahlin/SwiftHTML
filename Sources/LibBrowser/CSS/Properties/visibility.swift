extension CSS {
    enum Visibility: CustomStringConvertible, EnumStringInit {
        case visible
        case hidden
        case collapse

        init?(value: String) {
            switch value {
            case "visible":
                self = .visible
            case "hidden":
                self = .hidden
            case "collapse":
                self = .collapse
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .visible:
                "visible"
            case .hidden:
                "hidden"
            case .collapse:
                "collapse"
            }
        }
    }
}
