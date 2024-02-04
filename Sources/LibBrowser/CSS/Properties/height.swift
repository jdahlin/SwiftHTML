extension CSS {
    enum Height: Equatable {
        case length(Length)
        case percentage(Number)
        case auto
        case maxContent
        case minContent
        case fitContent(LengthOrPercentage?)
    }
}

extension CSS.StyleProperties {
    func parseHeight(context: CSS.ParseContext) -> CSS.StyleValue? {
        // FIXME: maxContent/minContent
        parseLengthPercentageOrAuto(context: context)
    }
}
