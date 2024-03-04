extension CSS {
    enum LineThickness: Equatable {
        case thin
        case medium
        case thick

        init?(value: String) {
            switch value {
            case "thin":
                self = .thin
            case "medium":
                self = .medium
            case "thick":
                self = .thick
            default:
                return nil
            }
        }
    }

    enum LineWidth: Equatable {
        case length(Length)
        case thickness(LineThickness)

        init(value: String) {
            switch value {
            case "thin":
                self = .thickness(.thin)
            case "medium":
                self = .thickness(.medium)
            case "thick":
                self = .thickness(.thick)
            default:
                DIE("line-width: \(value) not implemented")
            }
        }
    }
}

extension CSS.LineThickness: CustomStringConvertible {
    var description: String {
        switch self {
        case .thin:
            "thin"
        case .medium:
            "medium"
        case .thick:
            "thick"
        }
    }
}

extension CSS.LineWidth: CustomStringConvertible {
    var description: String {
        switch self {
        case let .length(length):
            "\(length)"
        case let .thickness(thickness):
            "\(thickness)"
        }
    }
}

extension CSS.LineWidth: CSSPropertyValue {
    typealias T = CSS.LineWidth

    init?(_ styleValue: CSS.StyleValue?) {
        guard let styleValue else { return nil }
        switch styleValue {
        case let .length(length):
            self = .length(length)
        case let .lineWidth(lineWidth):
            self = lineWidth
        default:
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        switch self {
        case let .length(length):
            .length(length)
        case let .thickness(thickness):
            .lineWidth(.thickness(thickness))
        }
    }
}

extension CSS.StyleProperties {
    func parseLineWidth(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        if declaration.count == 1 {
            if let lineWidth = parseLineWidth(value: declaration[0]) {
                return .lineWidth(lineWidth)
            }
        }
        return nil
    }

    func parseLineWidth(value: CSS.ComponentValue) -> CSS.LineWidth? {
        switch value {
        case let .token(.ident(ident)):
            if let thickness = CSS.LineThickness(value: ident) {
                return .thickness(thickness)
            }
        default:
            if let length = parseLength(value: value) {
                return .length(length)
            }
        }
        return nil
    }
}
