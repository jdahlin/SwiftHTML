extension CSS {
    enum LineStyle: Equatable {
        case none
        case hidden
        case dotted
        case dashed
        case solid
        case double
        case groove
        case ridge
        case inset
        case outset

        init?(value: String) {
            switch value {
            case "none":
                self = .none
            case "hidden":
                self = .hidden
            case "dotted":
                self = .dotted
            case "dashed":
                self = .dashed
            case "solid":
                self = .solid
            case "double":
                self = .double
            case "groove":
                self = .groove
            case "ridge":
                self = .ridge
            case "inset":
                self = .inset
            case "outset":
                self = .outset
            default:
                return nil
            }
        }
    }
}

extension CSS.LineStyle: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:
            "none"
        case .hidden:
            "hidden"
        case .dotted:
            "dotted"
        case .dashed:
            "dashed"
        case .solid:
            "solid"
        case .double:
            "double"
        case .groove:
            "groove"
        case .ridge:
            "ridge"
        case .inset:
            "inset"
        case .outset:
            "outset"
        }
    }
}

extension CSS.LineStyle: CSSPropertyValue {
    typealias T = CSS.LineStyle

    init?(_ styleValue: CSS.StyleValue?) {
        guard let styleValue else {
            return nil
        }
        switch styleValue {
        case let .lineStyle(lineStyle):
            self = lineStyle
        default:
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        .lineStyle(self)
    }
}

extension CSS.StyleProperties {
    func parseLineStyle(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        if let value = parseLineStyle(value: declaration[0]) {
            return .lineStyle(value)
        }
        return nil
    }

    func parseLineStyle(value: CSS.ComponentValue) -> CSS.LineStyle? {
        switch value {
        case let .token(.ident(ident)):
            CSS.LineStyle(value: ident)
        default:
            nil
        }
    }
}
