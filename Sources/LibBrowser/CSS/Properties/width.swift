extension CSS {}

extension CSS.StyleProperties {
    func parseWidth(context: CSS.ParseContext) -> CSS.StyleValue? {
        parseSize(context: context)
    }
}
