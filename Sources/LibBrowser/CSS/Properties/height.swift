extension CSS {
    typealias Height = LengthOrPercentageOrAuto

    static func parseHeight(context: ParseContext) -> Property<Height> {
        parseLengthOrPercentageOrAuto(context: context)
    }
}
