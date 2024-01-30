extension CSS {
    // 6.1 Relative Lengths
    // https://www.w3.org/TR/css-values-4/#relative-lengths
    enum RelativeLength: CustomStringConvertible {
        // 6.1.1 Font-relative Lengths
        // https://www.w3.org/TR/css-values-4/#font-relative-lengths

        // Equal to the computed value of the font-size property of the element on which it is used.
        case em(Number)

        // Equal to the computed value of the em unit on the root element.
        case rem(Number)

        // Equal to the used x-height of the first available font
        case ex(Number)

        // Equal to the value of the ex unit on the root element.
        case rex(Number)

        // Equal to the used cap-height of the first available font
        case cap(Number)

        // Equal to the value of the cap unit on the root element.
        case rcap(Number)

        // Represents the typical advance measure of European alphanumeric
        // characters, and measured as the used advance measure of the “0”
        // (ZERO, U+0030) glyph in the font used to render it.
        case ch(Number)

        // Equal to the value of the ch unit on the root element.
        case rch(Number)

        // Represents the typical advance measure of CJK letters, and measured
        // as the used advance measure of the “水” (CJK water ideograph, U+6C34)
        // glyph found in the font used to render it.
        case ic(Number)

        // Equal to the value of the ic unit on the root element.
        case ric(Number)

        // Equal to the computed value of the line-height property of the
        // element on which it is used, converting normal to an absolute length
        // by using only the metrics of the first available font.
        case lh(Number)

        // Equal to the value of the lh unit on the root element.
        case rlh(Number)

        // 6.1.2 Viewport-percentage Lengths
        // https://www.w3.org/TR/css-values-4/#viewport-relative-lengths
        // https://www.w3.org/TR/css-values-4/#viewport-variants

        // Equal to 1% of the width of the viewport size
        case vw(Number)

        // Equal to 1% of the width of the small viewport size
        case svw(Number)

        // Equal to 1% of the width of the large viewport size
        case lvw(Number)

        // Equal to 1% of the width of the dynamic viewport size
        case dvw(Number)

        // Equal to 1% of the height of the viewport size
        case vh(Number)

        // Equal to 1% of the height of the small viewport size
        case svh(Number)

        // Equal to 1% of the height of the large viewport size
        case lvh(Number)

        // Equal to 1% of the height of the dynamic viewport size
        case dvh(Number)

        // Equal to 1% of the size of the viewport size in the box’s inline
        // axis.
        case vi(Number)

        // Equal to 1% of the size of the small viewport size in the box’s
        // inline axis.
        case svi(Number)

        // Equal to 1% of the size of the large viewport size in the box’s
        // inline axis.
        case lvi(Number)

        // Equal to 1% of the size of the dynamic viewport size in the box’s
        // inline axis.
        case dvi(Number)

        // Equal to 1% of the size of the initial containing block of the
        // viewport size in the box’s block axis.
        case vb(Number)

        // Equal to 1% of the size of the initial containing block of the
        // small viewport size in the box’s block axis.
        case svb(Number)

        // Equal to 1% of the size of the initial containing block of the
        // large viewport size in the box’s block axis.
        case lvb(Number)

        // Equal to 1% of the size of the initial containing block of the
        // dynamic viewport size in the box’s block axis.
        case dvb(Number)

        // Equal to the smaller of vw and vh
        case vmin(Number)

        // Equal to the smaller of svw and svh
        case svmin(Number)

        // Equal to the smaller of lvw and lvh
        case lvmin(Number)

        // Equal to the smaller of dvw and dvh
        case dvmin(Number)

        // Equal to the larger of vw and vh
        case vmax(Number)

        // Equal to the larger of svw and svh
        case svmax(Number)

        // Equal to the larger of lvw and lvh
        case lvmax(Number)

        // Equal to the larger of dvw and dvh
        case dvmax(Number)

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
        case px(Number)
        case cm(Number)
        case mm(Number)
        case Q(Number)
        case inch(Number)
        case pc(Number)
        case pt(Number)

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

    enum Length: CustomStringConvertible {
        case relative(RelativeLength)
        case absolute(AbsoluteLength)

        init(number: Number, unit: String) {
            switch unit {
            case "px":
                self = .absolute(.px(number))
            case "cm":
                self = .absolute(.cm(number))
            case "mm":
                self = .absolute(.mm(number))
            case "Q":
                self = .absolute(.Q(number))
            case "in":
                self = .absolute(.inch(number))
            case "pc":
                self = .absolute(.pc(number))
            case "pt":
                self = .absolute(.pt(number))
            case "em":
                self = .relative(.em(number))
            case "rem":
                self = .relative(.rem(number))
            case "ex":
                self = .relative(.ex(number))
            case "rex":
                self = .relative(.rex(number))
            case "cap":
                self = .relative(.cap(number))
            case "rcap":
                self = .relative(.rcap(number))
            case "ch":
                self = .relative(.ch(number))
            case "rch":
                self = .relative(.rch(number))
            case "ic":
                self = .relative(.ic(number))
            case "ric":
                self = .relative(.ric(number))
            case "lh":
                self = .relative(.lh(number))
            case "rlh":
                self = .relative(.rlh(number))
            case "vw":
                self = .relative(.vw(number))
            case "svw":
                self = .relative(.svw(number))
            case "lvw":
                self = .relative(.lvw(number))
            case "dvw":
                self = .relative(.dvw(number))
            case "vh":
                self = .relative(.vh(number))
            case "svh":
                self = .relative(.svh(number))
            case "lvh":
                self = .relative(.lvh(number))
            case "dvh":
                self = .relative(.dvh(number))
            case "vi":
                self = .relative(.vi(number))
            case "svi":
                self = .relative(.svi(number))
            case "lvi":
                self = .relative(.lvi(number))
            case "dvi":
                self = .relative(.dvi(number))
            case "vb":
                self = .relative(.vb(number))
            case "svb":
                self = .relative(.svb(number))
            case "lvb":
                self = .relative(.lvb(number))
            case "dvb":
                self = .relative(.dvb(number))
            case "vmin":
                self = .relative(.vmin(number))
            case "svmin":
                self = .relative(.svmin(number))
            case "lvmin":
                self = .relative(.lvmin(number))
            case "dvmin":
                self = .relative(.dvmin(number))
            case "vmax":
                self = .relative(.vmax(number))
            case "svmax":
                self = .relative(.svmax(number))
            case "lvmax":
                self = .relative(.lvmax(number))
            case "dvmax":
                self = .relative(.dvmax(number))

            default:
                DIE("length: \(unit) not implemented")
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
}
