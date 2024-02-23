import AppKit

protocol CSSPropertyValue {
    associatedtype T
    init?(_ styleValue: CSS.StyleValue?)
    func styleValue() -> CSS.StyleValue
}

extension CSS {
    class StyleProperties {
        @StylePropertyWrapper<CSS.Color>(.backgroundColor, initial: .color(InitialValues.backgroundColor)) var backgroundColor
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
