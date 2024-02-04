extension CSS {
    // 6.1 Relative Lengths
    // https://www.w3.org/TR/css-values-4/#relative-lengths
    enum RelativeLength: CustomStringConvertible {
        // 6.1.1 Font-relative Lengths
        // https://www.w3.org/TR/css-values-4/#font-relative-lengths

        // Equal to the computed value of the font-size property of the element on which it is used.
        case em(Double)

        // Equal to the computed value of the em unit on the root element.
        case rem(Double)

        // Equal to the used x-height of the first available font
        case ex(Double)

        // Equal to the value of the ex unit on the root element.
        case rex(Double)

        // Equal to the used cap-height of the first available font
        case cap(Double)

        // Equal to the value of the cap unit on the root element.
        case rcap(Double)

        // Represents the typical advance measure of European alphanumeric
        // characters, and measured as the used advance measure of the “0”
        // (ZERO, U+0030) glyph in the font used to render it.
        case ch(Double)

        // Equal to the value of the ch unit on the root element.
        case rch(Double)

        // Represents the typical advance measure of CJK letters, and measured
        // as the used advance measure of the “水” (CJK water ideograph, U+6C34)
        // glyph found in the font used to render it.
        case ic(Double)

        // Equal to the value of the ic unit on the root element.
        case ric(Double)

        // Equal to the computed value of the line-height property of the
        // element on which it is used, converting normal to an absolute length
        // by using only the metrics of the first available font.
        case lh(Double)

        // Equal to the value of the lh unit on the root element.
        case rlh(Double)

        // 6.1.2 Viewport-percentage Lengths
        // https://www.w3.org/TR/css-values-4/#viewport-relative-lengths
        // https://www.w3.org/TR/css-values-4/#viewport-variants

        // Equal to 1% of the width of the viewport size
        case vw(Double)

        // Equal to 1% of the width of the small viewport size
        case svw(Double)

        // Equal to 1% of the width of the large viewport size
        case lvw(Double)

        // Equal to 1% of the width of the dynamic viewport size
        case dvw(Double)

        // Equal to 1% of the height of the viewport size
        case vh(Double)

        // Equal to 1% of the height of the small viewport size
        case svh(Double)

        // Equal to 1% of the height of the large viewport size
        case lvh(Double)

        // Equal to 1% of the height of the dynamic viewport size
        case dvh(Double)

        // Equal to 1% of the size of the viewport size in the box’s inline
        // axis.
        case vi(Double)

        // Equal to 1% of the size of the small viewport size in the box’s
        // inline axis.
        case svi(Double)

        // Equal to 1% of the size of the large viewport size in the box’s
        // inline axis.
        case lvi(Double)

        // Equal to 1% of the size of the dynamic viewport size in the box’s
        // inline axis.
        case dvi(Double)

        // Equal to 1% of the size of the initial containing block of the
        // viewport size in the box’s block axis.
        case vb(Double)

        // Equal to 1% of the size of the initial containing block of the
        // small viewport size in the box’s block axis.
        case svb(Double)

        // Equal to 1% of the size of the initial containing block of the
        // large viewport size in the box’s block axis.
        case lvb(Double)

        // Equal to 1% of the size of the initial containing block of the
        // dynamic viewport size in the box’s block axis.
        case dvb(Double)

        // Equal to the smaller of vw and vh
        case vmin(Double)

        // Equal to the smaller of svw and svh
        case svmin(Double)

        // Equal to the smaller of lvw and lvh
        case lvmin(Double)

        // Equal to the smaller of dvw and dvh
        case dvmin(Double)

        // Equal to the larger of vw and vh
        case vmax(Double)

        // Equal to the larger of svw and svh
        case svmax(Double)

        // Equal to the larger of lvw and lvh
        case lvmax(Double)

        // Equal to the larger of dvw and dvh
        case dvmax(Double)

        var description: String {
            switch self {
            case let .em(value): "\(value)em"
            case let .rem(value): "\(value)rem"
            case let .ex(value): "\(value)ex"
            case let .rex(value): "\(value)rex"
            case let .cap(value): "\(value)cap"
            case let .rcap(value): "\(value)rcap"
            case let .ch(value): "\(value)ch"
            case let .rch(value): "\(value)rch"
            case let .ic(value): "\(value)ic"
            case let .ric(value): "\(value)ric"
            case let .lh(value): "\(value)lh"
            case let .rlh(value): "\(value)rlh"
            case let .vw(value): "\(value)vw"
            case let .svw(value): "\(value)svw"
            case let .lvw(value): "\(value)lvw"
            case let .dvw(value): "\(value)dvw"
            case let .vh(value): "\(value)vh"
            case let .svh(value): "\(value)svh"
            case let .lvh(value): "\(value)lvh"
            case let .dvh(value): "\(value)dvh"
            case let .vi(value): "\(value)vi"
            case let .svi(value): "\(value)svi"
            case let .lvi(value): "\(value)lvi"
            case let .dvi(value): "\(value)dvi"
            case let .vb(value): "\(value)vb"
            case let .svb(value): "\(value)svb"
            case let .lvb(value): "\(value)lvb"
            case let .dvb(value): "\(value)dvb"
            case let .vmin(value): "\(value)vmin"
            case let .svmin(value): "\(value)svmin"
            case let .lvmin(value): "\(value)lvmin"
            case let .dvmin(value): "\(value)dvmin"
            case let .vmax(value): "\(value)vmax"
            case let .svmax(value): "\(value)svmax"
            case let .lvmax(value): "\(value)lvmax"
            case let .dvmax(value): "\(value)dvmax"
            }
        }
    }

    // https://www.w3.org/TR/css-values-4/#absolute-lengths
    enum AbsoluteLength: CustomStringConvertible {
        case px(Double)
        case cm(Double)
        case mm(Double)
        case Q(Double)
        case inch(Double)
        case pc(Double)
        case pt(Double)

        var description: String {
            switch self {
            case let .px(number): "\(number)px"
            case let .cm(number): "\(number)cm"
            case let .mm(number): "\(number)mm"
            case let .Q(number): "\(number)Q"
            case let .inch(number): "\(number)in"
            case let .pc(number): "\(number)pc"
            case let .pt(number): "\(number)pt"
            }
        }
    }

    enum Length: CustomStringConvertible {
        case relative(RelativeLength)
        case absolute(AbsoluteLength)

        init(number: Double, unit: String) {
            self = switch unit {
            case "px": .absolute(.px(number))
            case "cm": .absolute(.cm(number))
            case "mm": .absolute(.mm(number))
            case "Q": .absolute(.Q(number))
            case "in": .absolute(.inch(number))
            case "pc": .absolute(.pc(number))
            case "pt": .absolute(.pt(number))
            case "em": .relative(.em(number))
            case "rem": .relative(.rem(number))
            case "ex": .relative(.ex(number))
            case "rex": .relative(.rex(number))
            case "cap": .relative(.cap(number))
            case "rcap": .relative(.rcap(number))
            case "ch": .relative(.ch(number))
            case "rch": .relative(.rch(number))
            case "ic": .relative(.ic(number))
            case "ric": .relative(.ric(number))
            case "lh": .relative(.lh(number))
            case "rlh": .relative(.rlh(number))
            case "vw": .relative(.vw(number))
            case "svw": .relative(.svw(number))
            case "lvw": .relative(.lvw(number))
            case "dvw": .relative(.dvw(number))
            case "vh": .relative(.vh(number))
            case "svh": .relative(.svh(number))
            case "lvh": .relative(.lvh(number))
            case "dvh": .relative(.dvh(number))
            case "vi": .relative(.vi(number))
            case "svi": .relative(.svi(number))
            case "lvi": .relative(.lvi(number))
            case "dvi": .relative(.dvi(number))
            case "vb": .relative(.vb(number))
            case "svb": .relative(.svb(number))
            case "lvb": .relative(.lvb(number))
            case "dvb": .relative(.dvb(number))
            case "vmin": .relative(.vmin(number))
            case "svmin": .relative(.svmin(number))
            case "lvmin": .relative(.lvmin(number))
            case "dvmin": .relative(.dvmin(number))
            case "vmax": .relative(.vmax(number))
            case "svmax": .relative(.svmax(number))
            case "lvmax": .relative(.lvmax(number))
            case "dvmax": .relative(.dvmax(number))
            default:
                DIE("length: \(unit) not implemented")
            }
        }

        var zeroPx: Self {
            .absolute(.px(0))
        }

        var description: String {
            switch self {
            case let .relative(relative):
                relative.description
            case let .absolute(absolute):
                absolute.description
            }
        }

        func absolutized(fontMeasurements: FontMeasurements) -> Length {
            switch self {
            case .absolute(.px):
                return self
            default:
                let pixels = toPx(fontMeasurements: fontMeasurements)
                let value = pixels.toDouble()
                return .absolute(.px(value))
            }
        }

        func absoluteLengthToPx() -> CSS.Pixels {
            let inchPixels = 96.0
            let cmPixels = (inchPixels / 2.54)
            let value = switch self {
            case let .absolute(.cm(value)):
                // 1cm = 96px/2.54
                value * cmPixels
            case let .absolute(.inch(value)):
                // 1in = 2.54 cm = 96px
                value * inchPixels
            case let .absolute(.px(value)):
                // 1px = 1/96th of 1in
                value
            case let .absolute(.pt(value)):
                // 1pt = 1/72th of 1in
                value * ((1.0 / 72.0) * inchPixels)
            case let .absolute(.pc(value)):
                // 1pc = 1/6th of 1in
                value * ((1.0 / 6.0) * inchPixels)
            case let .absolute(.mm(value)):
                // 1mm = 1/10th of 1cm
                value * ((1.0 / 10.0) * cmPixels)
            case let .absolute(.Q(value)):
                // 1Q = 1/40th of 1cm
                value * ((1.0 / 40.0) * cmPixels)
            default:
                preconditionFailure()
            }
            return CSS.Pixels.nearestValueFor(value)
        }

        func toPx(fontMeasurements: FontMeasurements) -> CSS.Pixels {
            switch self {
            case .absolute:
                absoluteLengthToPx()
            case let .relative(.em(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.fontSize)
            case let .relative(.rem(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.fontSize)
            case let .relative(.ex(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.xHeight)
            case let .relative(.rex(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.xHeight)
            case let .relative(.cap(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.capHeight)
            case let .relative(.rcap(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.capHeight)
            case let .relative(.ch(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.zeroAdvance)
            case let .relative(.rch(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.zeroAdvance)
            case let .relative(.ic(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.fontSize)
            case let .relative(.ric(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.fontSize)
            case let .relative(.lh(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.fontMetrics.lineHeight)
            case let .relative(.rlh(value)):
                CSS.Pixels.nearestValueFor(value * fontMeasurements.rootFontMetrics.lineHeight)
            case let .relative(.vw(value)),
                 let .relative(.svw(value)),
                 let .relative(.lvw(value)),
                 let .relative(.dvw(value)):
                fontMeasurements.viewportRect.width * (CSS.Pixels.nearestValueFor(value) / 100)
            case let .relative(.vh(value)),
                 let .relative(.svh(value)),
                 let .relative(.lvh(value)),
                 let .relative(.dvh(value)):
                fontMeasurements.viewportRect.height * (CSS.Pixels.nearestValueFor(value) / 100)
            case let .relative(.vi(value)),
                 let .relative(.svi(value)),
                 let .relative(.lvi(value)),
                 let .relative(.dvi(value)):
                // FIXME: Select the width or height based on which is the inline axis.
                fontMeasurements.viewportRect.width * (CSS.Pixels.nearestValueFor(value) / 100)
            case let .relative(.vb(value)),
                 let .relative(.svb(value)),
                 let .relative(.lvb(value)),
                 let .relative(.dvb(value)):
                // FIXME: Select the width or height based on which is the block axis.
                fontMeasurements.viewportRect.height * (CSS.Pixels.nearestValueFor(value) / 100)
            case let .relative(.vmin(value)),
                 let .relative(.svmin(value)),
                 let .relative(.lvmin(value)),
                 let .relative(.dvmin(value)):
                min(fontMeasurements.viewportRect.width,
                    fontMeasurements.viewportRect.height) * (CSS.Pixels.nearestValueFor(value) / 100)
            case let .relative(.vmax(value)),
                 let .relative(.svmax(value)),
                 let .relative(.lvmax(value)),
                 let .relative(.dvmax(value)):
                max(fontMeasurements.viewportRect.width,
                    fontMeasurements.viewportRect.height) * (CSS.Pixels.nearestValueFor(value) / 100)
            }
        }
    }
}

extension CSS.AbsoluteLength: Equatable {}

extension CSS.RelativeLength: Equatable {}

extension CSS.Length: Equatable {}
