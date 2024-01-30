extension CSS {
    enum UnicodeBidi: CustomStringConvertible, EnumStringInit {
        case normal
        case embed
        case bidiOverride
        case isolate
        case isolateOverride
        case plaintext

        init?(value: String) {
            switch value {
            case "normal":
                self = .normal
            case "embed":
                self = .embed
            case "bidi-override":
                self = .bidiOverride
            case "isolate":
                self = .isolate
            case "isolate-override":
                self = .isolateOverride
            case "plaintext":
                self = .plaintext
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .normal:
                "normal"
            case .embed:
                "embed"
            case .bidiOverride:
                "bidi-override"
            case .isolate:
                "isolate"
            case .isolateOverride:
                "isolate-override"
            case .plaintext:
                "plaintext"
            }
        }
    }
}
