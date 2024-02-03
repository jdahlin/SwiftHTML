extension CSS {
    enum SystemColor {
        case accentColor
        case accentColorText
        case activeText
        case buttonBorder
        case buttonFace
        case buttonText
        case canvas
        case canvasText
        case field
        case fieldText
        case grayText
        case highlight
        case highlightText
        case linkText
        case mark
        case markText
        case placeholderText
        case visitedText
        case window
        case windowText
    }

    enum Color {
        case hex(String)
        case function(ColorFunction)
        case named(CSS.Color.Named)
        // case colorMix()
        case transparent

        case rgb(Double, Double, Double)
        case rgba(Double, Double, Double, Double)
        case hsl(Double, Double, Double)
        case hsla(Double, Double, Double, Double)
        case currentColor
        case system(SystemColor)
        case unset
        // case colorFunction
    }

    enum ColorFunction {
        case rgb(Double, Double, Double)
        case rgba(Double, Double, Double, Double)
        case hsl(Double, Double, Double)
        case hsla(Double, Double, Double, Double)
        case hwb(Double, Double, Double)
        case lab(Double, Double, Double)
        case lch(Double, Double, Double)
        case oklab(Double, Double, Double)
        case oklch(Double, Double, Double)
        case color(String)
    }
}
