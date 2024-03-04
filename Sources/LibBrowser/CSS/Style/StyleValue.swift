extension CSS {
    enum StyleValue: CustomStringConvertible {
        case appearance(Appearance)
        case auto
        case color(Color)
        case display(Display)
        case fontSize(FontSize)
        case inherit
        case initial
        case length(Length)
        case lineHeight(LineHeight)
        case lineStyle(LineStyle)
        case lineWidth(LineWidth)
        case percentage(Percentage)
        case revert
        case size(Size)
        case unresolved
        case unset

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
            case let .lineStyle(value):
                "lineStyle(\(value))"
            case let .lineWidth(value):
                "lineWidth(\(value))"
            case let .percentage(value):
                "percentage(\(value))"
            case .revert:
                "revert"
            case .unset:
                "unset"
            case let .size(value):
                "size(\(value))"
            case .unresolved:
                "unresolved"
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

extension CSS.StyleValue: Equatable {}
