extension CSS {
    typealias Width = LengthOrPercentageOrAuto

    static func parseWidth(context: ParseContext) -> Property<Width> {
        parseLengthOrPercentageOrAuto(context: context)
    }
}
