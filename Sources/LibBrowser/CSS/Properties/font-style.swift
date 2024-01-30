// 2.4. Font style: the font-style property
// https://drafts.csswg.org/css-fonts/#font-style-prop
extension CSS {
    enum FontStyle: CustomStringConvertible, EnumStringInit {
        case normal
        case italic
        case oblique

        init?(value: String) {
            switch value {
            case "normal":
                self = .normal
            case "italic":
                self = .italic
            case "oblique":
                self = .oblique
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .normal:
                "normal"
            case .italic:
                "italic"
            case .oblique:
                "oblique"
            }
        }
    }
}
