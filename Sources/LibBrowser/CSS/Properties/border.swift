extension CSS.StyleProperties {
    // border =
    //   <line-width>  ||
    //   <line-style>  ||
    //   <color>

    // <line-width> =
    //   <length [0,∞]>  |
    //   thin            |
    //   medium          |
    //   thick

    // <line-style> =
    //   none    |
    //   hidden  |
    //   dotted  |
    //   dashed  |
    //   solid   |
    //   double  |
    //   groove  |
    //   ridge   |
    //   inset   |
    //   outset
    func parseBorderShortHand(context: CSS.ParseContext) {
        let declaration = context.parseDeclaration()
        guard declaration.count <= 3 else {
            return
        }
        for value in declaration.componentValues {
            if let color = parseColor(value: value) {
                borderTopColor = color
                borderRightColor = color
                borderBottomColor = color
                borderLeftColor = color
            } else if let lineStyle = parseLineStyle(value: value) {
                borderTopStyle = lineStyle
                borderRightStyle = lineStyle
                borderBottomStyle = lineStyle
                borderLeftStyle = lineStyle
            } else if let lineWidth = parseLineWidth(value: value) {
                borderTopWidth = lineWidth
                borderRightWidth = lineWidth
                borderBottomWidth = lineWidth
                borderLeftWidth = lineWidth
            } else {
                FIXME("Unknown value for border: \(value)")
            }
        }
    }
}
