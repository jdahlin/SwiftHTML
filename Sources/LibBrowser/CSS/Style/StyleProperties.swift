import AppKit

protocol CSSPropertyValue {
    associatedtype T
    init?(_ styleValue: CSS.StyleValue?)
    func styleValue() -> CSS.StyleValue
}

extension CSS {
    class StyleProperties {
        @StylePropertyWrapper<CSS.Color>(.backgroundColor) var backgroundColor
        @StylePropertyWrapper<CSS.Color>(.color, inherited: true) var color
        @StylePropertyWrapper<CSS.Display>(.display) var display
        @StylePropertyWrapper<CSS.FontSize>(.fontSize, inherited: true) var fontSize
        @StylePropertyWrapper<CSS.Length>(.insetBlockStart) var insetBlockStart
        @StylePropertyWrapper<CSS.Length>(.insetInlineStart) var insetInlineStart
        @StylePropertyWrapper<CSS.Length>(.insetBlockEnd) var insetBlockEnd
        @StylePropertyWrapper<CSS.Length>(.insetInlineEnd) var insetInlineEnd
        @StylePropertyWrapper<CSS.LineHeight>(.lineHeight) var lineHeight
        @StylePropertyWrapper<CSS.Length>(.marginTop) var marginTop
        @StylePropertyWrapper<CSS.Length>(.marginRight) var marginRight
        @StylePropertyWrapper<CSS.Length>(.marginBottom) var marginBottom
        @StylePropertyWrapper<CSS.Length>(.marginLeft) var marginLeft
        @StylePropertyWrapper<CSS.Length>(.paddingTop) var paddingTop
        @StylePropertyWrapper<CSS.Length>(.paddingRight) var paddingRight
        @StylePropertyWrapper<CSS.Length>(.paddingBottom) var paddingBottom
        @StylePropertyWrapper<CSS.Length>(.paddingLeft) var paddingLeft
        @StylePropertyWrapper<CSS.Length>(.top) var top
        @StylePropertyWrapper<CSS.Length>(.right) var right
        @StylePropertyWrapper<CSS.Length>(.bottom) var bottom
        @StylePropertyWrapper<CSS.Length>(.left) var left
        @StylePropertyWrapper<CSS.Size>(.width) var width
        @StylePropertyWrapper<CSS.Size>(.height) var height

        var computedFont: CTFont?

        func parseGlobalKeywords(_ value: CSS.ComponentValue) -> StyleValue? {
            switch value {
            case let .token(.ident(ident)):
                parseGlobalKeywords(ident)
            default:
                nil
            }
        }

        func parseGlobalKeywords(_ value: String) -> StyleValue? {
            switch value {
            case "initial": .initial
            case "inherit": .inherit
            case "unset": .unset
            case "revert": .revert
            default: nil
            }
        }

        func setProperty(id: PropertyID, value: StyleValue?) {
            guard var property = getProperty(id: id) else {
                DIE("setProperty: \(id) not implemented")
            }
            property.value = value
        }

        func getProperty(id: PropertyID) -> StyleProperty? {
            switch id {
            case .backgroundColor: return $backgroundColor
            case .color: return $color
            case .display: return $display
            case .fontSize: return $fontSize
            case .lineHeight: return $lineHeight
            case .marginBottom: return $marginBottom
            case .marginLeft: return $marginLeft
            case .marginRight: return $marginRight
            case .marginTop: return $marginTop
            case .paddingBottom: return $paddingBottom
            case .paddingLeft: return $paddingLeft
            case .paddingRight: return $paddingRight
            case .paddingTop: return $paddingTop
            case .insetBlockEnd: return $insetBlockEnd
            case .insetBlockStart: return $insetBlockStart
            case .insetInlineEnd: return $insetInlineEnd
            case .insetInlineStart: return $insetInlineStart
            case .top: return $top
            case .right: return $right
            case .bottom: return $bottom
            case .left: return $left
            case .width: return $width
            case .height: return $height
            case .all, .margin, .padding:
                FIXME("getProperty: \(id) not implemented")
                return nil
            }
        }

        func parseCSSValue(name: String, componentValues: [CSS.ComponentValue]) {
            let context = ParseContext(componentValues: componentValues, name: name)

            switch name {
            case "display":
                if let value = parseDisplay(context: context) {
                    display = CSS.Display(value)
                }
            case "background-color":
                if let value = parseColor(context: context) {
                    backgroundColor = CSS.Color(value)
                }
            case "color":
                if let value = parseColor(context: context) {
                    color = CSS.Color(value)
                }
            case "font-size":
                if let value = parseFontSize(context: context) {
                    fontSize = CSS.FontSize(value)
                }
            case "inset-block-start":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetBlockStart = CSS.Length(value)
                }
            case "inset-inline-start":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetInlineStart = CSS.Length(value)
                }
            case "inset-block-end":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetBlockEnd = CSS.Length(value)
                }
            case "inset-inline-end":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetInlineEnd = CSS.Length(value)
                }
            case "line-height":
                if let value = parseLineHeight(context: context) {
                    lineHeight = CSS.LineHeight(value)
                }
            case "margin":
                parseMarginShortHand(context: context)
            case "margin-top":
                if let value = parseMargin(context: context) {
                    marginTop = CSS.Length(value)
                }
            case "margin-right":
                if let value = parseMargin(context: context) {
                    marginRight = CSS.Length(value)
                }
            case "margin-bottom":
                if let value = parseMargin(context: context) {
                    marginBottom = CSS.Length(value)
                }
            case "margin-left":
                if let value = parseMargin(context: context) {
                    marginLeft = CSS.Length(value)
                }
            case "padding":
                parsePaddingShortHand(context: context)
            case "padding-top":
                if let value = parsePadding(context: context) {
                    paddingTop = CSS.Length(value)
                }
            case "padding-right":
                if let value = parsePadding(context: context) {
                    paddingRight = CSS.Length(value)
                }
            case "padding-bottom":
                if let value = parsePadding(context: context) {
                    paddingBottom = CSS.Length(value)
                }
            case "padding-left":
                if let value = parsePadding(context: context) {
                    paddingLeft = CSS.Length(value)
                }
            case "top":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    top = CSS.Length(value)
                }
            case "right":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    right = CSS.Length(value)
                }
            case "bottom":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    bottom = CSS.Length(value)
                }
            case "left":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    left = CSS.Length(value)
                }
            case "width":
                if let value = parseWidth(context: context) {
                    width = CSS.Size(value)
                }
            case "height":
                if let value = parseHeight(context: context) {
                    height = CSS.Size(value)
                }
            default:
                FIXME("parseCSSValue: \(name) not implemented")
            }
        }

        func toStringDict() -> [String: String] {
            var dict: [String: String] = [:]
            for (property, value) in toDict() {
                dict["\(property)"] = "\(value!)"
            }
            return dict
        }

        func toDict() -> [PropertyID: StyleValue?] {
            var dict: [PropertyID: StyleValue] = [:]
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if let property = child.value as? StyleProperty {
                    dict[property.id] = property.value
                }
            }
            return dict
        }

        func setComputedFont(font: CTFont) {
            computedFont = font
        }

        func calculateLineHeight(fontMeasurements: FontMeasurements) -> CSS.Pixels {
            switch lineHeight {
            case .normal:
                return fontMeasurements.fontMetrics.lineHeight
            default:
                FIXME("lineHeight: \(String(describing: lineHeight)) not implemented, defaulting to normal")
                return fontMeasurements.fontMetrics.lineHeight
            }
        }
    }
}

extension CSS.StyleProperties: Sequence {
    func makeIterator() -> AnyIterator<CSS.StyleProperty> {
        let mirror = Mirror(reflecting: self)
        let properties = mirror.children.compactMap { $0.value as? CSS.StyleProperty }
        var index = 0
        return AnyIterator {
            guard index < properties.count else {
                return nil
            }
            defer { index += 1 }
            return properties[index]
        }
    }
}
