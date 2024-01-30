extension CSS {
    enum TextDecorationLine: CustomStringConvertible, EnumStringInit {
        case none
        case underline
        case overline
        case lineThrough
        case blink

        init?(value: String) {
            switch value {
            case "none":
                self = .none
            case "underline":
                self = .underline
            case "overline":
                self = .overline
            case "line-through":
                self = .lineThrough
            case "blink":
                self = .blink
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .none:
                "none"
            case .underline:
                "underline"
            case .overline:
                "overline"
            case .lineThrough:
                "line-through"
            case .blink:
                "blink"
            }
        }
    }
}
