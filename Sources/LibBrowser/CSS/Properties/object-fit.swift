// 4.5. Sizing Objects: the object-fit property
// https://drafts.csswg.org/css-images/#the-object-fit
extension CSS {
    enum ObjectFit: CustomStringConvertible, EnumStringInit {
        case fill
        case contain
        case cover
        case none
        case scaleDown

        init?(value: String) {
            switch value {
            case "fill":
                self = .fill
            case "contain":
                self = .contain
            case "cover":
                self = .cover
            case "none":
                self = .none
            case "scale-down":
                self = .scaleDown
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .fill:
                "fill"
            case .contain:
                "contain"
            case .cover:
                "cover"
            case .none:
                "none"
            case .scaleDown:
                "scale-down"
            }
        }
    }
}
