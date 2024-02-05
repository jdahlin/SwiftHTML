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

extension CSS.StyleProperties {
    func parseColor(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        if case let .token(.ident(ident)) = declaration[0] {
            if let named = CSS.Color.Named(string: ident) {
                return .color(.named(named))
            }
            if let system = CSS.Color.System(string: ident) {
                return .color(.system(system))
            }
            FIXME("Don't know how to parse color: \(ident)")
        }
        return nil
    }
}

extension CSS.Color: CSSPropertyValue {
    typealias T = CSS.Color

    init?(_ styleValue: CSS.StyleValue?) {
        switch styleValue {
        case let .color(color):
            self = color
        case nil:
            return nil
        default:
            FIXME("Unable to convert color from StyleValue: \(styleValue!)")
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        .color(self)
    }
}
