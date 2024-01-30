extension CSS {
    enum Overflow: CustomStringConvertible, EnumStringInit {
        case visible
        case hidden
        case clip
        case scroll
        case auto
        case initial
        case inherit

        init?(value: String) {
            switch value {
            case "visible":
                self = .visible
            case "hidden":
                self = .hidden
            case "clip":
                self = .clip
            case "scroll":
                self = .scroll
            case "auto":
                self = .auto
            case "initial":
                self = .initial
            case "inherit":
                self = .inherit
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
            case .clip:
                "clip"
            case .scroll:
                "scroll"
            case .auto:
                "auto"
            case .initial:
                "initial"
            case .inherit:
                "inherit"
            }
        }
    }
}
