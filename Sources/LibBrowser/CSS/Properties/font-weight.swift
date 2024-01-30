extension CSS {
    enum FontWeight: CustomStringConvertible, EnumStringInit {
        case normal
        case bold
        case bolder
        case lighter
        case w100
        case w200
        case w300
        case w400
        case w500
        case w600
        case w700
        case w800
        case w900

        init?(value: String) {
            switch value {
            case "normal":
                self = .normal
            case "bold":
                self = .bold
            case "bolder":
                self = .bolder
            case "lighter":
                self = .lighter
            case "100":
                self = .w100
            case "200":
                self = .w200
            case "300":
                self = .w300
            case "400":
                self = .w400
            case "500":
                self = .w500
            case "600":
                self = .w600
            case "700":
                self = .w700
            case "800":
                self = .w800
            case "900":
                self = .w900
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .normal:
                "normal"
            case .bold:
                "bold"
            case .bolder:
                "bolder"
            case .lighter:
                "lighter"
            case .w100:
                "100"
            case .w200:
                "200"
            case .w300:
                "300"
            case .w400:
                "400"
            case .w500:
                "500"
            case .w600:
                "600"
            case .w700:
                "700"
            case .w800:
                "800"
            case .w900:
                "900"
            }
        }
    }
}
