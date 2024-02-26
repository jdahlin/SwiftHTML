extension CSS {
    enum Size: Equatable {
        case length(Length)
        case percentage(Percentage)
        case auto
        case none
        case maxContent
        case minContent
        case fitContent(LengthOrPercentage?)

        init(pixels: CSS.Pixels) {
            self = .length(.absolute(.px(pixels.toDouble())))
        }

        func toPx(node: Layout.Node, referenceValue: CSS.Pixels) -> CSS.Pixels {
            switch self {
            case let .length(length):
                length.absoluteLengthToPx()
            case let .percentage(percentage):
                CSS.Pixels(percentage.value * referenceValue.toDouble())
            case .auto, .none, .maxContent, .minContent:
                DIE()
            case let .fitContent(lengthOrPercentage):
                lengthOrPercentage?.toPx(layoutNode: node, referenceValue: referenceValue) ?? CSS.Pixels(0)
            }
        }

        func containsPercentage() -> Bool {
            switch self {
            case .length:
                false
            case .percentage:
                true
            case .auto, .none, .maxContent, .minContent, .fitContent:
                false
            }
        }

        func resolved(layoutNode _: Layout.Node, referenceValue: CSS.Pixels) -> Length {
            switch self {
            case let .length(length):
                length
            case let .percentage(percentage):
                .absolute(.px(percentage.value * referenceValue.toDouble() / 100))
            case .auto, .none, .maxContent, .minContent, .fitContent:
                DIE()
            }
        }
    }
}

extension CSS.StyleProperties {
    func parseSize(context: CSS.ParseContext) -> CSS.StyleValue? {
        if let value = parseLengthPercentageOrAuto(context: context) {
            return value
        }
        FIXME("parse none/maxContent/minContent")
        return nil
    }
}

extension CSS.Size: CSSPropertyValue {
    typealias T = CSS.Size

    init?(_ styleValue: CSS.StyleValue?) {
        switch styleValue {
        case let .size(size):
            self = size
        case let .length(length):
            self = .length(length)
        case nil:
            return nil
        default:
            FIXME("Unable to convert size from StyleValue: \(styleValue!)")
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        .size(self)
    }
}
