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
        if case let .length(length) = parseLength(context: context) {
            return .lineWidth(.length(length))
        }
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        if case let .token(.ident(ident)) = declaration[0],
           let thickness = CSS.LineThickness(value: ident)
        {
            return .lineWidth(.thickness(thickness))
        }
        return nil
    }
}
