extension CSS {
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
        case system(CSS.Color.System)
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

extension CSS.Color: Equatable {}

extension CSS.ColorFunction: Equatable {}
