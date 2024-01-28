// 2.2. Base Color: the background-color property
// https://drafts.csswg.org/css-backgrounds/#background-color
extension CSS.Properties {
    enum GlobalCSSValue {
        case initial
        case inherit
        case unset
    }

    enum BackgroundColor {
        case color(CSS.Color)
        case global(GlobalCSSValue)
    }
}
