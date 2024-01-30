extension CSS {
    enum Whitespace: CustomStringConvertible, EnumStringInit {
        case normal
        case nowrap
        case pre
        case preWrap
        case preLine

        init?(value: String) {
            switch value {
            case "normal":
                self = .normal
            case "nowrap":
                self = .nowrap
            case "pre":
                self = .pre
            case "pre-wrap":
                self = .preWrap
            case "pre-line":
                self = .preLine
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .normal:
                "normal"
            case .nowrap:
                "nowrap"
            case .pre:
                "pre"
            case .preWrap:
                "pre-wrap"
            case .preLine:
                "pre-line"
            }
        }
    }
}
