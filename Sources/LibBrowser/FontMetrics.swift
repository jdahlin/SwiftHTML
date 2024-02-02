import AppKit
import CoreText

package struct FontPixelMetrics {
    var size: Float
    var xHeight: Float
    var advanceOfAsciiZero: Float
    var glyphSpacing: Float
    var ascent: Float
    var descent: Float
    var lineGap: Float

    func lineSpacing() -> Float {
        ascent + descent + lineGap
    }
}

package struct FontMetrics {
    var fontSize: CSS.Pixels
    // CTFontGetSize(font)
    var lineHeight: CSS.Pixels
    // CTFontGetAscent(font) + CTFontGetDescent(font) + CTFontGetLeading(font)

    var xHeight: CSS.Pixels
    // CTFontGetXHeight(font)

    var capHeight: CSS.Pixels
    // CTFontGetCapHeight(font)

    var zeroAdvance: CSS.Pixels
    // CTFontGetAdvancesForGlyphs(font, .horizontal, [0], nil, 1)

    init(fontSize: CSS.Pixels, lineHeight: CSS.Pixels, pixelMetrics: FontPixelMetrics) {
        self.fontSize = fontSize
        xHeight = CSS.Pixels(pixelMetrics.xHeight)
        self.lineHeight = lineHeight
        xHeight = CSS.Pixels(pixelMetrics.xHeight)
        capHeight = CSS.Pixels(pixelMetrics.ascent)
        zeroAdvance = CSS.Pixels(pixelMetrics.advanceOfAsciiZero + pixelMetrics.glyphSpacing)
    }
}

extension CTFont {
    static var defaultFont = CTFontCreateWithName("Helvetica" as CFString, 14.0, nil)

    func pixelMetrics() -> FontPixelMetrics {
        let size = CTFontGetSize(self)
        let xHeight = CTFontGetXHeight(self)
        let zero = [UniChar(0x0030)]
        var glyph = [CGGlyph(0)]
        var advancement = CGSize.zero
        CTFontGetGlyphsForCharacters(self, zero, &glyph, 1)
        CTFontGetAdvancesForGlyphs(self, .horizontal, glyph, &advancement, 1)
        let glyphSpacing = advancement.width - CTFontGetAdvancesForGlyphs(self, .horizontal, [0], nil, 1)
        let ascent = CTFontGetAscent(self)
        let descent = CTFontGetDescent(self)
        let lineGap = CTFontGetLeading(self)

        return FontPixelMetrics(
            size: Float(size),
            xHeight: Float(xHeight),
            advanceOfAsciiZero: Float(advancement.width),
            glyphSpacing: Float(glyphSpacing),
            ascent: Float(ascent),
            descent: Float(descent),
            lineGap: Float(lineGap)
        )
    }
}

func calculateTextSize(text: String, fontName: String, fontSize: CGFloat) -> CGSize {
    let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1
    paragraphStyle.maximumLineHeight = CTFontGetAscent(font) + CTFontGetDescent(font) + CTFontGetLeading(font)
    paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping

    let framesetter = CTFramesetterCreateWithAttributedString(NSAttributedString(string: text, attributes: [
        NSAttributedString.Key.ligature: 0,
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.kern: 0,
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
    ]))
    let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
        framesetter,
        CFRangeMake(0, text.count),
        nil,
        CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
        nil
    )

    return suggestedSize
}
