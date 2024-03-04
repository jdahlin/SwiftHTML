import AppKit

protocol CSSPropertyValue {
    associatedtype T
    init?(_ styleValue: CSS.StyleValue?)
    func styleValue() -> CSS.StyleValue
}

extension CSS {
    class StyleProperties {
        @StylePropertyWrapper<Color>(.backgroundColor, initial: .color(InitialValues.backgroundColor)) var backgroundColor
        @StylePropertyWrapper<Color>(.borderTopColor, initial: .color(InitialValues.borderTopColor)) var borderTopColor
        @StylePropertyWrapper<LineStyle>(.borderTopStyle, initial: .lineStyle(InitialValues.borderTopStyle)) var borderTopStyle
        @StylePropertyWrapper<LineWidth>(.borderTopWidth, initial: .lineWidth(InitialValues.borderTopWidth)) var borderTopWidth
        @StylePropertyWrapper<Color>(.borderRightColor, initial: .color(InitialValues.borderRightColor)) var borderRightColor
        @StylePropertyWrapper<LineStyle>(.borderRightStyle, initial: .lineStyle(InitialValues.borderRightStyle)) var borderRightStyle
        @StylePropertyWrapper<LineWidth>(.borderRightWidth, initial: .lineWidth(InitialValues.borderRightWidth)) var borderRightWidth
        @StylePropertyWrapper<Color>(.borderBottomColor, initial: .color(InitialValues.borderBottomColor)) var borderBottomColor
        @StylePropertyWrapper<LineStyle>(.borderBottomStyle, initial: .lineStyle(InitialValues.borderBottomStyle)) var borderBottomStyle
        @StylePropertyWrapper<LineWidth>(.borderBottomWidth, initial: .lineWidth(InitialValues.borderBottomWidth)) var borderBottomWidth
        @StylePropertyWrapper<Color>(.borderLeftColor, initial: .color(InitialValues.borderLeftColor)) var borderLeftColor
        @StylePropertyWrapper<LineStyle>(.borderLeftStyle, initial: .lineStyle(InitialValues.borderLeftStyle)) var borderLeftStyle
        @StylePropertyWrapper<LineWidth>(.borderLeftWidth, initial: .lineWidth(InitialValues.borderLeftWidth)) var borderLeftWidth
        @StylePropertyWrapper<Color>(.color, initial: .color(InitialValues.color), inherited: true) var color
        @StylePropertyWrapper<Display>(.display, initial: .display(InitialValues.display)) var display
        @StylePropertyWrapper<FontSize>(.fontSize, initial: .fontSize(.length(.absolute(.px(InitialValues.fontSize.toDouble())))), inherited: true) var fontSize
        @StylePropertyWrapper<Length>(.insetBlockStart, initial: .length(InitialValues.insetBlockStart)) var insetBlockStart
        @StylePropertyWrapper<Length>(.insetInlineStart, initial: .length(InitialValues.insetInlineStart)) var insetInlineStart
        @StylePropertyWrapper<Length>(.insetBlockEnd, initial: .length(InitialValues.insetBlockEnd)) var insetBlockEnd
        @StylePropertyWrapper<Length>(.insetInlineEnd, initial: .length(InitialValues.insetInlineEnd)) var insetInlineEnd
        @StylePropertyWrapper<LineHeight>(.lineHeight, initial: .lineHeight(InitialValues.lineHeight)) var lineHeight
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.marginTop, initial: InitialValues.margin.top.styleValue()) var marginTop
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.marginRight, initial: InitialValues.margin.right.styleValue()) var marginRight
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.marginBottom, initial: InitialValues.margin.bottom.styleValue()) var marginBottom
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.marginLeft, initial: InitialValues.margin.left.styleValue()) var marginLeft
        @StylePropertyWrapper<LengthOrPercentage>(.paddingTop, initial: InitialValues.padding.top.styleValue()) var paddingTop
        @StylePropertyWrapper<LengthOrPercentage>(.paddingRight, initial: InitialValues.padding.right.styleValue()) var paddingRight
        @StylePropertyWrapper<LengthOrPercentage>(.paddingBottom, initial: InitialValues.padding.bottom.styleValue()) var paddingBottom
        @StylePropertyWrapper<LengthOrPercentage>(.paddingLeft, initial: InitialValues.padding.left.styleValue()) var paddingLeft
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.top, initial: InitialValues.inset.top.styleValue()) var top
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.right, initial: InitialValues.inset.right.styleValue()) var right
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.bottom, initial: InitialValues.inset.bottom.styleValue()) var bottom
        @StylePropertyWrapper<LengthOrPercentageOrAuto>(.left, initial: InitialValues.inset.left.styleValue()) var left
        @StylePropertyWrapper<Size>(.width, initial: .size(InitialValues.width)) var width
        @StylePropertyWrapper<Size>(.height, initial: .size(InitialValues.height)) var height
        @StylePropertyWrapper<Color>(.outlineColor, initial: .color(InitialValues.outlineColor)) var outlineColor
        @StylePropertyWrapper<LineStyle>(.outlineStyle, initial: .lineStyle(InitialValues.outlineStyle)) var outlineStyle
        @StylePropertyWrapper<LineWidth>(.outlineWidth, initial: .lineWidth(InitialValues.outlineWidth)) var outlineWidth

        var computedFont: CTFont?

        func parseGlobalKeywords(_ value: ComponentValue) -> StyleValue? {
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

        func parseCSSValue(name: String, componentValues: [ComponentValue]) {
            let context = ParseContext(componentValues: componentValues, name: name)

            switch name {
            case "display":
                if let value = parseDisplay(context: context) {
                    display = Display(value)
                }
            case "background-color":
                if let value = parseColor(context: context) {
                    backgroundColor = Color(value)
                }
            case "border":
                parseBorderShortHand(context: context)
            case "border-top-color":
                if let value = parseColor(context: context) {
                    borderTopColor = Color(value)
                }
            case "border-top-style":
                if let value = parseLineStyle(context: context) {
                    borderTopStyle = LineStyle(value)
                }
            case "border-top-width":
                if let value = parseLineWidth(context: context) {
                    borderTopWidth = LineWidth(value)
                }
            case "border-right-color":
                if let value = parseColor(context: context) {
                    borderRightColor = Color(value)
                }
            case "border-right-style":
                if let value = parseLineStyle(context: context) {
                    borderRightStyle = LineStyle(value)
                }
            case "border-right-width":
                if let value = parseLineWidth(context: context) {
                    borderRightWidth = LineWidth(value)
                }
            case "border-bottom-color":
                if let value = parseColor(context: context) {
                    borderBottomColor = Color(value)
                }
            case "border-bottom-style":
                if let value = parseLineStyle(context: context) {
                    borderBottomStyle = LineStyle(value)
                }
            case "border-bottom-width":
                if let value = parseLineWidth(context: context) {
                    borderBottomWidth = LineWidth(value)
                }
            case "border-left-color":
                if let value = parseColor(context: context) {
                    borderLeftColor = Color(value)
                }
            case "border-left-style":
                if let value = parseLineStyle(context: context) {
                    borderLeftStyle = LineStyle(value)
                }
            case "border-left-width":
                if let value = parseLineWidth(context: context) {
                    borderLeftWidth = LineWidth(value)
                }
            case "color":
                if let value = parseColor(context: context) {
                    color = Color(value)
                }
            case "font-size":
                if let value = parseFontSize(context: context) {
                    fontSize = FontSize(value)
                }
            case "inset-block-start":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetBlockStart = Length(value)
                }
            case "inset-inline-start":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetInlineStart = Length(value)
                }
            case "inset-block-end":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetBlockEnd = Length(value)
                }
            case "inset-inline-end":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    insetInlineEnd = Length(value)
                }
            case "line-height":
                if let value = parseLineHeight(context: context) {
                    lineHeight = LineHeight(value)
                }
            case "margin":
                parseMarginShortHand(context: context)
            case "margin-top":
                if let value = parseMargin(context: context) {
                    marginTop = LengthOrPercentageOrAuto(value)
                }
            case "margin-right":
                if let value = parseMargin(context: context) {
                    marginRight = LengthOrPercentageOrAuto(value)
                }
            case "margin-bottom":
                if let value = parseMargin(context: context) {
                    marginBottom = LengthOrPercentageOrAuto(value)
                }
            case "margin-left":
                if let value = parseMargin(context: context) {
                    marginLeft = LengthOrPercentageOrAuto(value)
                }
            case "padding":
                parsePaddingShortHand(context: context)
            case "padding-top":
                if let value = parsePadding(context: context) {
                    paddingTop = LengthOrPercentage(value)
                }
            case "padding-right":
                if let value = parsePadding(context: context) {
                    paddingRight = LengthOrPercentage(value)
                }
            case "padding-bottom":
                if let value = parsePadding(context: context) {
                    paddingBottom = LengthOrPercentage(value)
                }
            case "padding-left":
                if let value = parsePadding(context: context) {
                    paddingLeft = LengthOrPercentage(value)
                }
            case "top":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    top = LengthOrPercentageOrAuto(value)
                }
            case "right":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    right = LengthOrPercentageOrAuto(value)
                }
            case "bottom":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    bottom = LengthOrPercentageOrAuto(value)
                }
            case "left":
                if let value = parseLengthPercentageOrAuto(context: context) {
                    left = LengthOrPercentageOrAuto(value)
                }
            case "width":
                if let value = parseWidth(context: context) {
                    width = Size(value)
                }
            case "height":
                if let value = parseHeight(context: context) {
                    height = Size(value)
                }
            case "outline":
                parseOutlineShortHand(context: context)
            case "outline-color":
                // FIXME: implement strip() parsing
                if let value = parseColor(context: context) {
                    outlineColor = Color(value)
                }
            case "outline-style":
                if let value = parseLineStyle(context: context) {
                    outlineStyle = LineStyle(value)
                }
            case "outline-width":
                if let value = parseLineWidth(context: context) {
                    outlineWidth = LineWidth(value)
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

        func calculateLineHeight(fontMeasurements: FontMeasurements) -> Pixels {
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
                       fallback _: LengthOrPercentageOrAuto) -> LengthBox
        {
            // FIXME: support percentage
            let top: LengthOrPercentageOrAuto = if let prop = getProperty(id: topId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let bottom: LengthOrPercentageOrAuto = if let prop = getProperty(id: bottomId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let left: LengthOrPercentageOrAuto = if let prop = getProperty(id: leftId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            let right: LengthOrPercentageOrAuto = if let prop = getProperty(id: rightId), case let .length(length) = prop.value {
                .length(length)
            } else {
                .auto
            }
            return LengthBox(top: top, right: right, bottom: bottom, left: left)
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
