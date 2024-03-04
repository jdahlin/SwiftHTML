import AppKit

protocol CSSPropertyValue {
    associatedtype T
    init?(_ styleValue: CSS.StyleValue?)
    func styleValue() -> CSS.StyleValue
}

extension CSS {
    class StyleProperties {
        @StylePropertyWrapper<CSS.Color>(.backgroundColor, initial: .color(InitialValues.backgroundColor)) var backgroundColor
        @StylePropertyWrapper<CSS.Color>(.borderTopColor, initial: .color(InitialValues.borderTopColor)) var borderTopColor
        @StylePropertyWrapper<CSS.LineStyle>(.borderTopStyle, initial: .lineStyle(InitialValues.borderTopStyle)) var borderTopStyle
        @StylePropertyWrapper<CSS.LineWidth>(.borderTopWidth, initial: .lineWidth(InitialValues.borderTopWidth)) var borderTopWidth
        @StylePropertyWrapper<CSS.Color>(.borderRightColor, initial: .color(InitialValues.borderRightColor)) var borderRightColor
        @StylePropertyWrapper<CSS.LineStyle>(.borderRightStyle, initial: .lineStyle(InitialValues.borderRightStyle)) var borderRightStyle
        @StylePropertyWrapper<CSS.LineWidth>(.borderRightWidth, initial: .lineWidth(InitialValues.borderRightWidth)) var borderRightWidth
        @StylePropertyWrapper<CSS.Color>(.borderBottomColor, initial: .color(InitialValues.borderBottomColor)) var borderBottomColor
        @StylePropertyWrapper<CSS.LineStyle>(.borderBottomStyle, initial: .lineStyle(InitialValues.borderBottomStyle)) var borderBottomStyle
        @StylePropertyWrapper<CSS.LineWidth>(.borderBottomWidth, initial: .lineWidth(InitialValues.borderBottomWidth)) var borderBottomWidth
        @StylePropertyWrapper<CSS.Color>(.borderLeftColor, initial: .color(InitialValues.borderLeftColor)) var borderLeftColor
        @StylePropertyWrapper<CSS.LineStyle>(.borderLeftStyle, initial: .lineStyle(InitialValues.borderLeftStyle)) var borderLeftStyle
        @StylePropertyWrapper<CSS.LineWidth>(.borderLeftWidth, initial: .lineWidth(InitialValues.borderLeftWidth)) var borderLeftWidth
        @StylePropertyWrapper<CSS.Color>(.color, initial: .color(InitialValues.color), inherited: true) var color
        @StylePropertyWrapper<CSS.Display>(.display, initial: .display(InitialValues.display)) var display
        @StylePropertyWrapper<CSS.FontSize>(.fontSize, initial: .fontSize(.length(.absolute(.px(InitialValues.fontSize.toDouble())))), inherited: true) var fontSize
        @StylePropertyWrapper<CSS.Length>(.insetBlockStart, initial: .length(InitialValues.insetBlockStart)) var insetBlockStart
        @StylePropertyWrapper<CSS.Length>(.insetInlineStart, initial: .length(InitialValues.insetInlineStart)) var insetInlineStart
        @StylePropertyWrapper<CSS.Length>(.insetBlockEnd, initial: .length(InitialValues.insetBlockEnd)) var insetBlockEnd
        @StylePropertyWrapper<CSS.Length>(.insetInlineEnd, initial: .length(InitialValues.insetInlineEnd)) var insetInlineEnd
        @StylePropertyWrapper<CSS.LineHeight>(.lineHeight, initial: .lineHeight(InitialValues.lineHeight)) var lineHeight
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.marginTop, initial: InitialValues.margin.top.styleValue()) var marginTop
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.marginRight, initial: InitialValues.margin.right.styleValue()) var marginRight
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.marginBottom, initial: InitialValues.margin.bottom.styleValue()) var marginBottom
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.marginLeft, initial: InitialValues.margin.left.styleValue()) var marginLeft
        @StylePropertyWrapper<CSS.LengthOrPercentage>(.paddingTop, initial: InitialValues.padding.top.styleValue()) var paddingTop
        @StylePropertyWrapper<CSS.LengthOrPercentage>(.paddingRight, initial: InitialValues.padding.right.styleValue()) var paddingRight
        @StylePropertyWrapper<CSS.LengthOrPercentage>(.paddingBottom, initial: InitialValues.padding.bottom.styleValue()) var paddingBottom
        @StylePropertyWrapper<CSS.LengthOrPercentage>(.paddingLeft, initial: InitialValues.padding.left.styleValue()) var paddingLeft
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.top, initial: InitialValues.inset.top.styleValue()) var top
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.right, initial: InitialValues.inset.right.styleValue()) var right
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.bottom, initial: InitialValues.inset.bottom.styleValue()) var bottom
        @StylePropertyWrapper<CSS.LengthOrPercentageOrAuto>(.left, initial: InitialValues.inset.left.styleValue()) var left
        @StylePropertyWrapper<CSS.Size>(.width, initial: .size(InitialValues.width)) var width
        @StylePropertyWrapper<CSS.Size>(.height, initial: .size(InitialValues.height)) var height
        @StylePropertyWrapper<CSS.Color>(.outlineColor, initial: .color(InitialValues.outlineColor)) var outlineColor
        @StylePropertyWrapper<CSS.LineStyle>(.outlineStyle, initial: .lineStyle(InitialValues.outlineStyle)) var outlineStyle
        @StylePropertyWrapper<CSS.LineWidth>(.outlineWidth, initial: .lineWidth(InitialValues.outlineWidth)) var outlineWidth

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

        func setProperty(id: PropertyID, value: StyleValue) {
            guard let property = getProperty(id: id) else {
                DIE("setProperty: \(id) not implemented")
            }
            property.value = value
        }

        func getProperty(id: PropertyID) -> StyleProperty? {
            switch id {
            case .backgroundColor: return $backgroundColor
            case .borderTopColor: return $borderTopColor
            case .borderTopStyle: return $borderTopStyle
            case .borderTopWidth: return $borderTopWidth
            case .borderRightColor: return $borderRightColor
            case .borderRightStyle: return $borderRightStyle
            case .borderRightWidth: return $borderRightWidth
            case .borderBottomColor: return $borderBottomColor
            case .borderBottomStyle: return $borderBottomStyle
            case .borderBottomWidth: return $borderBottomWidth
            case .borderLeftColor: return $borderLeftColor
            case .borderLeftStyle: return $borderLeftStyle
            case .borderLeftWidth: return $borderLeftWidth
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
            case .outlineColor: return $outlineColor
            case .outlineStyle: return $outlineStyle
            case .outlineWidth: return $outlineWidth
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
            case "border":
                parseBorderShortHand(context: context)
            case "border-top-color":
                if let value = parseColor(context: context) {
                    borderTopColor = CSS.Color(value)
                }
            case "border-top-style":
                if let value = parseLineStyle(context: context) {
                    borderTopStyle = CSS.LineStyle(value)
                }
            case "border-top-width":
                if let value = parseLineWidth(context: context) {
                    borderTopWidth = CSS.LineWidth(value)
                }
            case "border-right-color":
                if let value = parseColor(context: context) {
                    borderRightColor = CSS.Color(value)
                }
            case "border-right-style":
                if let value = parseLineStyle(context: context) {
                    borderRightStyle = CSS.LineStyle(value)
                }
            case "border-right-width":
                if let value = parseLineWidth(context: context) {
                    borderRightWidth = CSS.LineWidth(value)
                }
            case "border-bottom-color":
                if let value = parseColor(context: context) {
                    borderBottomColor = CSS.Color(value)
                }
            case "border-bottom-style":
                if let value = parseLineStyle(context: context) {
                    borderBottomStyle = CSS.LineStyle(value)
                }
            case "border-bottom-width":
                if let value = parseLineWidth(context: context) {
                    borderBottomWidth = CSS.LineWidth(value)
                }
            case "border-left-color":
                if let value = parseColor(context: context) {
                    borderLeftColor = CSS.Color(value)
                }
            case "border-left-style":
                if let value = parseLineStyle(context: context) {
                    borderLeftStyle = CSS.LineStyle(value)
                }
            case "border-left-width":
                if let value = parseLineWidth(context: context) {
                    borderLeftWidth = CSS.LineWidth(value)
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
                    marginTop = CSS.LengthOrPercentageOrAuto(value)
                }
            case "margin-right":
                if let value = parseMargin(context: context) {
                    marginRight = CSS.LengthOrPercentageOrAuto(value)
                }
            case "margin-bottom":
                if let value = parseMargin(context: context) {
                    marginBottom = CSS.LengthOrPercentageOrAuto(value)
                }
            case "margin-left":
                if let value = parseMargin(context: context) {
                    marginLeft = CSS.LengthOrPercentageOrAuto(value)
                }
            case "padding":
                parsePaddingShortHand(context: context)
            case "padding-top":
                if let value = parsePadding(context: context) {
                    paddingTop = CSS.LengthOrPercentage(value)
                }
            case "padding-right":
                if let value = parsePadding(context: context) {
                    paddingRight = CSS.LengthOrPercentage(value)
                }
            case "padding-bottom":
                if let value = parsePadding(context: context) {
                    paddingBottom = CSS.LengthOrPercentage(value)
                }
            case "padding-left":
                if let value = parsePadding(context: context) {
                    paddingLeft = CSS.LengthOrPercentage(value)
                }
            case "top":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    top = CSS.LengthOrPercentageOrAuto(value)
                }
            case "right":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    right = CSS.LengthOrPercentageOrAuto(value)
                }
            case "bottom":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    bottom = CSS.LengthOrPercentageOrAuto(value)
                }
            case "left":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    left = CSS.LengthOrPercentageOrAuto(value)
                }
            case "width":
                if let value = parseWidth(context: context) {
                    width = CSS.Size(value)
                }
            case "height":
                if let value = parseHeight(context: context) {
                    height = CSS.Size(value)
                }
            case "outline":
                parseOutlineShortHand(context: context)
            case "outline-color":
                // FIXME: implement strip() parsing
                if let value = parseColor(context: context) {
                    outlineColor = CSS.Color(value)
                }
            case "outline-style":
                if let value = parseLineStyle(context: context) {
                    outlineStyle = CSS.LineStyle(value)
                }
            case "outline-width":
                if let value = parseLineWidth(context: context) {
                    outlineWidth = CSS.LineWidth(value)
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
                if let propertyWrapper = child.value as? AnyPropertyValue {
                    if propertyWrapper.valueAsAny as? StyleValue != nil {
                        dict[propertyWrapper.id] = propertyWrapper.property.value
                    }
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

        func lengthBox(leftId: PropertyID,
                       rightId: PropertyID,
                       topId: PropertyID,
                       bottomId: PropertyID,
                       fallback _: CSS.LengthOrPercentageOrAuto) -> CSS.LengthBox
        {
            // FIXME: support percentage
            let top: CSS.LengthOrPercentageOrAuto = if let prop = getProperty(id: topId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let bottom: CSS.LengthOrPercentageOrAuto = if let prop = getProperty(id: bottomId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let left: CSS.LengthOrPercentageOrAuto = if let prop = getProperty(id: leftId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let right: CSS.LengthOrPercentageOrAuto = if let prop = getProperty(id: rightId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            return CSS.LengthBox(top: top, right: right, bottom: bottom, left: left)
        }
    }
}

extension CSS.StyleProperties: Sequence {
    func makeIterator() -> AnyIterator<CSS.StyleProperty> {
        let mirror = Mirror(reflecting: self)
        let iterator = mirror.children.makeIterator()
        return AnyIterator {
            while let child = iterator.next() {
                if let propertyWrapper = child.value as? AnyPropertyValue {
                    if let _ = propertyWrapper.valueAsAny as? CSS.StyleValue {
                        return propertyWrapper.property
                    }
                }
            }
            return nil
        }
    }
}
