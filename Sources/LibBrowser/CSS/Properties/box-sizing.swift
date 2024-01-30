extension CSS {
    enum BoxSizing: CustomStringConvertible, EnumStringInit {
        case contentBox
        case borderBox

        init?(value: String) {
            switch value {
            case "content-box":
                self = .contentBox
            case "border-box":
                self = .borderBox
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .contentBox:
                "content-box"
            case .borderBox:
                "border-box"
            }
        }
    }
}
