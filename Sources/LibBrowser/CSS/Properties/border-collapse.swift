// 17.6. Borders
// https://drafts.csswg.org/css2/#propdef-border-collapse
extension CSS {
    enum BorderCollapse: CustomStringConvertible, EnumStringInit {
        case collapse
        case separate

        init?(value: String) {
            switch value {
            case "collapse":
                self = .collapse
            case "separate":
                self = .separate
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .collapse:
                "collapse"
            case .separate:
                "separate"
            }
        }
    }
}
