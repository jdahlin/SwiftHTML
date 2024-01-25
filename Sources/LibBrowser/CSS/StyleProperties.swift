extension CSS {
    enum Properties {}
    enum Unit {}
    enum Inherited {
        case inherited
        case no
    }

    typealias Length = Double
    typealias Percentage = Double

    enum ComponentValueType {
        case keyword(String)
        case length
        case percentage
    }

    enum LengthPercentage {
        case length(Double)
        case percentage(Percentage)
        case auto
    }

    struct Property {
        var name: String
        var value: [ComponentValueType]
        var initial: Double
    }
}

extension CSS.Properties {
    static let properties: [CSS.Property] = [
        CSS.Property(
            name: "margin-top",
            value: [.length, .percentage, .keyword("auto")],
            initial: 0.0
        ),
        CSS.Property(
            name: "margin-right",
            value: [.length, .percentage, .keyword("auto")],
            initial: 0.0
        ),
        CSS.Property(
            name: "margin-bottom",
            value: [.length, .percentage, .keyword("auto")],
            initial: 0.0
        ),
        CSS.Property(
            name: "margin-left",
            value: [.length, .percentage, .keyword("auto")],
            initial: 0.0
        ),
    ]
}

extension CSS.Unit {
    // 6.1 Relative Lengths
    // https://www.w3.org/TR/css-values-4/#relative-lengths
    enum RelativeLength {
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
    }

    // https://www.w3.org/TR/css-values-4/#absolute-lengths
    enum AbsoluteLength {
        case cm(Double)
        case mm(Double)
        case Q(Double)
        case inch(Double)
        case pc(Double)
        case pt(Double)
    }
}
