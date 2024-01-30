extension CSS {
    enum Direction: CustomStringConvertible, EnumStringInit {
        case ltr
        case rtl

        init?(value: String) {
            switch value {
            case "ltr":
                self = .ltr
            case "rtl":
                self = .rtl
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .ltr:
                "ltr"
            case .rtl:
                "rtl"
            }
        }
    }
}
