// 7.2. Switching appearance: the appearance property
// https://drafts.csswg.org/css-ui/#appearance-switching
extension CSS {
    enum Appearance: CustomStringConvertible, EnumStringInit {
        case none
        case auto

        init(value: String) {
            switch value {
            case "none":
                self = .none
            case "auto":
                self = .auto
            default:
                DIE("Appearance: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .none:
                "none"
            case .auto:
                "auto"
            }
        }
    }
}
