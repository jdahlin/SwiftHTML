extension CSS {
    enum StyleValue: CustomStringConvertible {
        case inherit
        case initial
        case revert
        case unset
        case appearance(Appearance)
        case display(Display)
        case fontSize(FontSize)
        case lineHeight(LineHeight)
        case margin(Margin)
        case padding(Padding)

        var description: String {
            switch self {
            case .inherit:
                "inherit"
            case .initial:
                "initial"
            case .revert:
                "revert"
            case .unset:
                "unset"
            case let .appearance(value):
                "appearance(\(value))"
            case let .display(value):
                "display(\(value))"
            case let .fontSize(value):
                "fontSize(\(value))"
            case let .lineHeight(value):
                "lineHeight(\(value))"
            case let .margin(value):
                "margin(\(value))"
            case let .padding(value):
                "padding(\(value))"
            }
        }

        func absolutized(fontMeasurements: FontMeasurements) -> StyleValue {
            switch self {
            case let .fontSize(.length(length)):
                .fontSize(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            case let .lineHeight(.length(length)):
                .lineHeight(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            case let .margin(.length(length)):
                .margin(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            case let .padding(.length(length)):
                .padding(.length(length.absolutized(fontMeasurements: fontMeasurements)))
            default:
                self
            }
        }
    }
}
