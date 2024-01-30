extension CSS {
    enum Position: CustomStringConvertible, EnumStringInit {
        case `static`
        case relative
        case absolute
        case fixed
        case sticky

        init?(value: String) {
            switch value {
            case "static":
                self = .static
            case "relative":
                self = .relative
            case "absolute":
                self = .absolute
            case "fixed":
                self = .fixed
            case "sticky":
                self = .sticky
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .static:
                "static"
            case .relative:
                "relative"
            case .absolute:
                "absolute"
            case .fixed:
                "fixed"
            case .sticky:
                "sticky"
            }
        }
    }
}
