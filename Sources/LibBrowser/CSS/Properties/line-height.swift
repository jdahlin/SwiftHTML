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

extension CSS.LineHeight: Equatable {
    static func == (lhs: CSS.LineHeight, rhs: CSS.LineHeight) -> Bool {
        switch (lhs, rhs) {
        case (.normal, .normal):
            true
        case let (.length(lhs), .length(rhs)):
            lhs == rhs
        case let (.percentage(lhs), .percentage(rhs)):
            lhs == rhs
        default:
            false
        }
    }
}
