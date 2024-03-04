extension CSS.StyleProperties {
    // outline =
    //   <'outline-color'>  ||
    //   <'outline-style'>  ||
    //   <'outline-width'>
    func parseOutlineShortHand(context: CSS.ParseContext) {
        let declaration = context.parseDeclaration()
        guard declaration.count <= 3 else {
            return
        }
        for value in declaration.componentValues {
            if let colorValue = parseColor(value: value) {
                outlineColor = colorValue
            } else if let styleValue = parseLineStyle(value: value) {
                outlineStyle = styleValue
            } else if let widthValue = parseLineWidth(value: value) {
                outlineWidth = widthValue
            } else {
                FIXME("Unknown value for outline: \(value)")
            }
        }
    }
}
