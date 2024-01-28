extension CSS.Properties {
    // Border shorthand
    // https://drafts.csswg.org/css-backgrounds/#propdef-border
    enum Border {
        case style(style: CSS.LineStyle)
        case widthStyle(width: Double, style: Double)
        case styleColor(style: Double, color: CSS.Color)
        case widthStyleColor(width: Double, style: Double, color: CSS.Color)
        // case global(global: Global)
        case unset
    }
}
