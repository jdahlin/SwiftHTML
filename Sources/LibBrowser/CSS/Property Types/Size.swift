extension CSS {
    enum Size: Equatable {
        case length(Length)
        case percentage(Number)
        case auto
        case maxContent
        case minContent
        case fitContent(LengthOrPercentage?)
    }
}

extension CSS.StyleProperties {
    func parseSize(context: CSS.ParseContext) -> CSS.StyleValue? {
        if let value = parseLengthPercentageOrAuto(context: context) {
            return value
        }
        FIXME("parse maxContent/minContent")
        return nil
    }
}
