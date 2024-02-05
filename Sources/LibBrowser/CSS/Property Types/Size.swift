extension CSS {
    enum Size: Equatable {
        case length(Length)
        case percentage(Number)
        case auto
        case none
        case maxContent
        case minContent
        case fitContent(LengthOrPercentage?)

        init(pixels: CSS.Pixels) {
            self = .length(.absolute(.px(pixels.toDouble())))
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
