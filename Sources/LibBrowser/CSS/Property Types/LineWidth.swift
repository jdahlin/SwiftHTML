extension CSS {
    enum LineWidth: CustomStringConvertible {
        case thin
        case medium
        case thick

        init(value: String) {
            switch value {
            case "thin":
                self = .thin
            case "medium":
                self = .medium
            case "thick":
                self = .thick
            default:
                DIE("line-width: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .thin:
                "thin"
            case .medium:
                "medium"
            case .thick:
                "thick"
            }
        }
    }
}
