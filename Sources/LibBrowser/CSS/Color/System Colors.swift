// https://drafts.csswg.org/css-color/#typedef-system-color
extension CSS.Color {
    enum System: CustomStringConvertible, Equatable {
        case accentColor
        case accentColorText
        case activeText
        case buttonBorder
        case buttonFace
        case buttonText
        case canvas
        case canvasText
        case field
        case fieldText
        case grayText
        case highlight
        case highlightText
        case linkText
        case mark
        case markText
        case placeholderText
        case visitedText
        case window
        case windowText

        init?(string: String) {
            switch string {
            case "AccentColor": self = .accentColor
            case "AccentColorText": self = .accentColorText
            case "ActiveText": self = .activeText
            case "ButtonBorder": self = .buttonBorder
            case "ButtonFace": self = .buttonFace
            case "ButtonText": self = .buttonText
            case "Canvas": self = .canvas
            case "CanvasText": self = .canvasText
            case "Field": self = .field
            case "FieldText": self = .fieldText
            case "GrayText": self = .grayText
            case "Highlight": self = .highlight
            case "HighlightText": self = .highlightText
            case "LinkText": self = .linkText
            case "Mark": self = .mark
            case "MarkText": self = .markText
            case "PlaceholderText": self = .placeholderText
            case "VisitedText": self = .visitedText
            case "Window": self = .window
            case "WindowText": self = .windowText
            default: return nil
            }
        }

        var description: String {
            switch self {
            case .accentColor: "AccentColor"
            case .accentColorText: "AccentColorText"
            case .activeText: "ActiveText"
            case .buttonBorder: "ButtonBorder"
            case .buttonFace: "ButtonFace"
            case .buttonText: "ButtonText"
            case .canvas: "Canvas"
            case .canvasText: "CanvasText"
            case .field: "Field"
            case .fieldText: "FieldText"
            case .grayText: "GrayText"
            case .highlight: "Highlight"
            case .highlightText: "HighlightText"
            case .linkText: "LinkText"
            case .mark: "Mark"
            case .markText: "MarkText"
            case .placeholderText: "PlaceholderText"
            case .visitedText: "VisitedText"
            case .window: "Window"
            case .windowText: "WindowText"
            }
        }
    }
}
