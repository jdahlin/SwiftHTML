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

extension CSS.Color: Equatable {
    static func == (lhs: CSS.Color, rhs: CSS.Color) -> Bool {
        switch (lhs, rhs) {
        case let (.hex(lhs), .hex(rhs)):
            lhs == rhs
        case let (.function(lhs), .function(rhs)):
            lhs == rhs
        case let (.named(lhs), .named(rhs)):
            lhs == rhs
        case (.transparent, .transparent):
            true
        case let (.rgb(r1, g1, b1), .rgb(r2, g2, b2)):
            r1 == r2 && g1 == g2 && b1 == b2
        case let (.rgba(r1, g1, b1, a1), .rgba(r2, g2, b2, a2)):
            r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
        case let (.hsl(h1, s1, l1), .hsl(h2, s2, l2)):
            h1 == h2 && s1 == s2 && l1 == l2
        case let (.hsla(h1, s1, l1, a1), .hsla(h2, s2, l2, a2)):
            h1 == h2 && s1 == s2 && l1 == l2 && a1 == a2
        case (.currentColor, .currentColor):
            true
        case let (.system(lhs), .system(rhs)):
            lhs == rhs
        case (.unset, .unset):
            true
        default:
            false
        }
    }
}

extension CSS.ColorFunction: Equatable {
    static func == (lhs: CSS.ColorFunction, rhs: CSS.ColorFunction) -> Bool {
        switch (lhs, rhs) {
        case let (.rgb(r1, g1, b1), .rgb(r2, g2, b2)):
            r1 == r2 && g1 == g2 && b1 == b2
        case let (.rgba(r1, g1, b1, a1), .rgba(r2, g2, b2, a2)):
            r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
        case let (.hsl(h1, s1, l1), .hsl(h2, s2, l2)):
            h1 == h2 && s1 == s2 && l1 == l2
        case let (.hsla(h1, s1, l1, a1), .hsla(h2, s2, l2, a2)):
            h1 == h2 && s1 == s2 && l1 == l2 && a1 == a2
        case let (.hwb(h1, w1, b1), .hwb(h2, w2, b2)):
            h1 == h2 && w1 == w2 && b1 == b2
        case let (.lab(l1, a1, b1), .lab(l2, a2, b2)):
            l1 == l2 && a1 == a2 && b1 == b2
        case let (.lch(l1, c1, h1), .lch(l2, c2, h2)):
            l1 == l2 && c1 == c2 && h1 == h2
        case let (.oklab(l1, a1, b1), .oklab(l2, a2, b2)):
            l1 == l2 && a1 == a2 && b1 == b2
        case let (.oklch(l1, c1, h1), .oklch(l2, c2, h2)):
            l1 == l2 && c1 == c2 && h1 == h2
        case let (.color(c1), .color(c2)):
            c1 == c2
        default:
            false
        }
    }
}
