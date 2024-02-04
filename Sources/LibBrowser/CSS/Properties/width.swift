extension CSS {
    enum Width: Equatable {
        case length(Length)
        case percentage(Number)
        case auto
        case maxContent
        case minContent
        case fitContent(LengthOrPercentage?)
    }
}

extension CSS.StyleProperties {
    func parseWidth(context: CSS.ParseContext) -> CSS.StyleValue? {
        // FIXME: maxContent/minContent
        parseLengthPercentageOrAuto(context: context)
    }
}
