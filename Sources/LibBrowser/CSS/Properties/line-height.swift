extension CSS {
    enum LineHeight: CustomStringConvertible {
        case normal
        case length(Length)
        case percentage(Number)

        var description: String {
            switch self {
            case .normal:
                "normal"
            case let .length(length):
                length.description
            case let .percentage(percentage):
                "\(percentage)%"
            }
        }
    }
}

extension CSS.StyleProperties {
    func parseLineHeight(context _: CSS.ParseContext) {
        FIXME("parse line-height")
        lineHeight.value = .lineHeight(.normal)
    }
}
