extension CSS {
    enum StyleValue: CustomStringConvertible {
        case inherit
        case initial
        case revert
        case unset
        case appearance(Appearance)
        case color(Color)
        case display(Display)
        case fontSize(FontSize)
        case lineHeight(LineHeight)
        case length(Length)
        case percentage(Number)
        case auto

        var description: String {
            switch self {
            case let .appearance(value):
                "appearance(\(value))"
            case .auto:
                "auto"
            case let .color(value):
                "color(\(value))"
            case let .display(value):
                "display(\(value))"
            case let .fontSize(value):
                "fontSize(\(value))"
            case .inherit:
                "inherit"
            case .initial:
                "initial"
            case let .length(value):
                "length(\(value))"
            case let .lineHeight(value):
                "lineHeight(\(value))"
            case let .percentage(value):
                "percentage(\(value))"
            case .revert:
                "revert"
            case .unset:
                "unset"
            }
        }

        func absolutized(fontMeasurements: FontMeasurements) -> StyleValue {
            switch self {
            case let .fontSize(.length(length)):
                .fontSize(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            case let .lineHeight(.length(length)):
                .lineHeight(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            case let .length(length):
                .length(length.absolutized(fontMeasurements: fontMeasurements))
            default:
                self
            }
        }
    }
}
