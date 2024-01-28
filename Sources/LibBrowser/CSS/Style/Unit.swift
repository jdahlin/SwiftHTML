extension CSS {
    enum Unit {
        enum Length: CustomStringConvertible {
            case relative(RelativeLength)
            case absolute(AbsoluteLength)

            init(unit: String) {
                switch unit {
                case "px":
                    self = .absolute(.px)
                case "cm":
                    self = .absolute(.cm)
                case "mm":
                    self = .absolute(.mm)
                case "Q":
                    self = .absolute(.Q)
                case "in":
                    self = .absolute(.inch)
                case "pc":
                    self = .absolute(.pc)
                case "pt":
                    self = .absolute(.pt)
                case "em":
                    self = .relative(.em)
                case "rem":
                    self = .relative(.rem)
                case "ex":
                    self = .relative(.ex)
                case "rex":
                    self = .relative(.rex)
                case "cap":
                    self = .relative(.cap)
                case "rcap":
                    self = .relative(.rcap)
                case "ch":
                    self = .relative(.ch)
                case "rch":
                    self = .relative(.rch)
                case "ic":
                    self = .relative(.ic)
                case "ric":
                    self = .relative(.ric)
                case "lh":
                    self = .relative(.lh)
                case "rlh":
                    self = .relative(.rlh)
                case "vw":
                    self = .relative(.vw)
                case "svw":
                    self = .relative(.svw)
                case "lvw":
                    self = .relative(.lvw)
                case "dvw":
                    self = .relative(.dvw)
                case "vh":
                    self = .relative(.vh)
                case "svh":
                    self = .relative(.svh)
                case "lvh":
                    self = .relative(.lvh)
                case "dvh":
                    self = .relative(.dvh)
                case "vi":
                    self = .relative(.vi)
                case "svi":
                    self = .relative(.svi)
                case "lvi":
                    self = .relative(.lvi)
                case "dvi":
                    self = .relative(.dvi)
                case "vb":
                    self = .relative(.vb)
                case "svb":
                    self = .relative(.svb)
                case "lvb":
                    self = .relative(.lvb)
                case "dvb":
                    self = .relative(.dvb)
                case "vmin":
                    self = .relative(.vmin)
                case "svmin":
                    self = .relative(.svmin)
                case "lvmin":
                    self = .relative(.lvmin)
                case "dvmin":
                    self = .relative(.dvmin)
                case "vmax":
                    self = .relative(.vmax)
                case "svmax":
                    self = .relative(.svmax)
                case "lvmax":
                    self = .relative(.lvmax)
                case "dvmax":
                    self = .relative(.dvmax)
                default:
                    DIE("should never happen: \(unit)")
                }
            }

            var description: String {
                switch self {
                case let .relative(unit):
                    unit.description
                case let .absolute(unit):
                    unit.description
                }
            }
        }

        // 6.1 Relative Lengths
        // https://www.w3.org/TR/css-values-4/#relative-lengths
        enum RelativeLength: CustomStringConvertible {
            // 6.1.1 Font-relative Lengths
            // https://www.w3.org/TR/css-values-4/#font-relative-lengths

            // Equal to the computed value of the font-size property of the element on which it is used.
            case em

            // Equal to the computed value of the em unit on the root element.
            case rem

            // Equal to the used x-height of the first available font
            case ex

            // Equal to the value of the ex unit on the root element.
            case rex

            // Equal to the used cap-height of the first available font
            case cap

            // Equal to the value of the cap unit on the root element.
            case rcap

            // Represents the typical advance measure of European alphanumeric
            // characters, and measured as the used advance measure of the “0”
            // (ZERO, U+0030) glyph in the font used to render it.
            case ch

            // Equal to the value of the ch unit on the root element.
            case rch

            // Represents the typical advance measure of CJK letters, and measured
            // as the used advance measure of the “水” (CJK water ideograph, U+6C34)
            // glyph found in the font used to render it.
            case ic

            // Equal to the value of the ic unit on the root element.
            case ric

            // Equal to the computed value of the line-height property of the
            // element on which it is used, converting normal to an absolute length
            // by using only the metrics of the first available font.
            case lh

            // Equal to the value of the lh unit on the root element.
            case rlh

            // 6.1.2 Viewport-percentage Lengths
            // https://www.w3.org/TR/css-values-4/#viewport-relative-lengths
            // https://www.w3.org/TR/css-values-4/#viewport-variants

            // Equal to 1% of the width of the viewport size
            case vw

            // Equal to 1% of the width of the small viewport size
            case svw

            // Equal to 1% of the width of the large viewport size
            case lvw

            // Equal to 1% of the width of the dynamic viewport size
            case dvw

            // Equal to 1% of the height of the viewport size
            case vh

            // Equal to 1% of the height of the small viewport size
            case svh

            // Equal to 1% of the height of the large viewport size
            case lvh

            // Equal to 1% of the height of the dynamic viewport size
            case dvh

            // Equal to 1% of the size of the viewport size in the box’s inline
            // axis.
            case vi

            // Equal to 1% of the size of the small viewport size in the box’s
            // inline axis.
            case svi

            // Equal to 1% of the size of the large viewport size in the box’s
            // inline axis.
            case lvi

            // Equal to 1% of the size of the dynamic viewport size in the box’s
            // inline axis.
            case dvi

            // Equal to 1% of the size of the initial containing block of the
            // viewport size in the box’s block axis.
            case vb

            // Equal to 1% of the size of the initial containing block of the
            // small viewport size in the box’s block axis.
            case svb

            // Equal to 1% of the size of the initial containing block of the
            // large viewport size in the box’s block axis.
            case lvb

            // Equal to 1% of the size of the initial containing block of the
            // dynamic viewport size in the box’s block axis.
            case dvb

            // Equal to the smaller of vw and vh
            case vmin

            // Equal to the smaller of svw and svh
            case svmin

            // Equal to the smaller of lvw and lvh
            case lvmin

            // Equal to the smaller of dvw and dvh
            case dvmin

            // Equal to the larger of vw and vh
            case vmax

            // Equal to the larger of svw and svh
            case svmax

            // Equal to the larger of lvw and lvh
            case lvmax

            // Equal to the larger of dvw and dvh
            case dvmax

            var description: String {
                switch self {
                case .em:
                    "em"
                case .rem:
                    "rem"
                case .ex:
                    "ex"
                case .rex:
                    "rex"
                case .cap:
                    "cap"
                case .rcap:
                    "rcap"
                case .ch:
                    "ch"
                case .rch:
                    "rch"
                case .ic:
                    "ic"
                case .ric:
                    "ric"
                case .lh:
                    "lh"
                case .rlh:
                    "rlh"
                case .vw:
                    "vw"
                case .svw:
                    "svw"
                case .lvw:
                    "lvw"
                case .dvw:
                    "dvw"
                case .vh:
                    "vh"
                case .svh:
                    "svh"
                case .lvh:
                    "lvh"
                case .dvh:
                    "dvh"
                case .vi:
                    "vi"
                case .svi:
                    "svi"
                case .lvi:
                    "lvi"
                case .dvi:
                    "dvi"
                case .vb:
                    "vb"
                case .svb:
                    "svb"
                case .lvb:
                    "lvb"
                case .dvb:
                    "dvb"
                case .vmin:
                    "vmin"
                case .svmin:
                    "svmin"
                case .lvmin:
                    "lvmin"
                case .dvmin:
                    "dvmin"
                case .vmax:
                    "vmax"
                case .svmax:
                    "svmax"
                case .lvmax:
                    "lvmax"
                case .dvmax:
                    "dvmax"
                }
            }
        }

        // https://www.w3.org/TR/css-values-4/#absolute-lengths
        enum AbsoluteLength: CustomStringConvertible {
            case px
            case cm
            case mm
            case Q
            case inch
            case pc
            case pt

            var description: String {
                switch self {
                case .px:
                    "px"
                case .cm:
                    "cm"
                case .mm:
                    "mm"
                case .Q:
                    "Q"
                case .inch:
                    "in"
                case .pc:
                    "pc"
                case .pt:
                    "pt"
                }
            }
        }
    }
}
