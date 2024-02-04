import AppKit

extension CSS {
    class StyleProperties {
        lazy var backgroundColor: StyleProperty = .init(id: .backgroundColor, initial: .color(.transparent))
        lazy var color: StyleProperty = .init(id: .color, initial: .color(.system(.canvasText)), inherited: true)
        lazy var display: StyleProperty = .init(id: .display, initial: .display(CSS.Display(outer: .inline, inner: .flow)))
        lazy var fontSize: StyleProperty = .init(id: .fontSize, initial: .fontSize(.absolute(.medium)), inherited: true)
        lazy var insetBlockStart: StyleProperty = .init(id: .insetBlockStart, initial: .auto)
        lazy var insetInlineStart: StyleProperty = .init(id: .insetInlineStart, initial: .auto)
        lazy var insetBlockEnd: StyleProperty = .init(id: .insetBlockEnd, initial: .auto)
        lazy var insetInlineEnd: StyleProperty = .init(id: .insetInlineEnd, initial: .auto)
        lazy var lineHeight: StyleProperty = .init(id: .lineHeight, initial: .lineHeight(.normal))
        lazy var marginTop: StyleProperty = .init(id: .marginTop, initial: .length(.absolute(.px(0))))
        lazy var marginRight: StyleProperty = .init(id: .marginRight, initial: .length(.absolute(.px(0))))
        lazy var marginBottom: StyleProperty = .init(id: .marginBottom, initial: .length(.absolute(.px(0))))
        lazy var marginLeft: StyleProperty = .init(id: .marginLeft, initial: .length(.absolute(.px(0))))
        lazy var paddingTop: StyleProperty = .init(id: .paddingTop, initial: .length(.absolute(.px(0))))
        lazy var paddingRight: StyleProperty = .init(id: .paddingRight, initial: .length(.absolute(.px(0))))
        lazy var paddingBottom: StyleProperty = .init(id: .paddingBottom, initial: .length(.absolute(.px(0))))
        lazy var paddingLeft: StyleProperty = .init(id: .paddingLeft, initial: .length(.absolute(.px(0))))
        lazy var top: StyleProperty = .init(id: .top, initial: .auto)
        lazy var right: StyleProperty = .init(id: .right, initial: .auto)
        lazy var bottom: StyleProperty = .init(id: .bottom, initial: .auto)
        lazy var left: StyleProperty = .init(id: .left, initial: .auto)
        lazy var width: StyleProperty = .init(id: .width, initial: .auto)
        lazy var height: StyleProperty = .init(id: .height, initial: .auto)

        var computedFont: CTFont?

        func marginBox() -> CSS.Box<Margin> {
            Box<Margin>(
                top: marginTop.margin(),
                right: marginRight.margin(),
                bottom: marginBottom.margin(),
                left: marginLeft.margin()
            )
        }

        func paddingBox() -> CSS.Box<Padding> {
            Box<Padding>(
                top: paddingTop.padding(),
                right: paddingRight.padding(),
                bottom: paddingBottom.padding(),
                left: paddingLeft.padding()
            )
        }

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
            switch id {
            case .backgroundColor:
                backgroundColor.value = value
            case .color:
                color.value = value
            case .display:
                display.value = value
            case .fontSize:
                fontSize.value = value
            case .insetBlockEnd:
                insetBlockEnd.value = value
            case .insetBlockStart:
                insetBlockStart.value = value
            case .insetInlineEnd:
                insetInlineEnd.value = value
            case .insetInlineStart:
                insetInlineStart.value = value
            case .lineHeight:
                lineHeight.value = value
            case .marginBottom:
                marginBottom.value = value
            case .marginLeft:
                marginLeft.value = value
            case .marginRight:
                marginRight.value = value
            case .marginTop:
                marginTop.value = value
            case .paddingBottom:
                paddingBottom.value = value
            case .paddingLeft:
                paddingLeft.value = value
            case .paddingRight:
                paddingRight.value = value
            case .paddingTop:
                paddingTop.value = value
            case .top:
                top.value = value
            case .right:
                right.value = value
            case .bottom:
                bottom.value = value
            case .left:
                left.value = value
            case .width:
                width.value = value
            case .height:
                height.value = value
            case .all, .margin, .padding:
                FIXME("setProperty: \(id) not implemented")
            }
        }

        func getProperty(id: PropertyID) -> StyleProperty? {
            switch id {
            case .backgroundColor: return backgroundColor
            case .color: return color
            case .display: return display
            case .fontSize: return fontSize
            case .lineHeight: return lineHeight
            case .marginBottom: return marginBottom
            case .marginLeft: return marginLeft
            case .marginRight: return marginRight
            case .marginTop: return marginTop
            case .paddingBottom: return paddingBottom
            case .paddingLeft: return paddingLeft
            case .paddingRight: return paddingRight
            case .paddingTop: return paddingTop
            case .insetBlockEnd: return insetBlockEnd
            case .insetBlockStart: return insetBlockStart
            case .insetInlineEnd: return insetInlineEnd
            case .insetInlineStart: return insetInlineStart
            case .top: return top
            case .right: return right
            case .bottom: return bottom
            case .left: return left
            case .width: return width
            case .height: return height
            case .all, .margin, .padding:
                FIXME("getProperty: \(id) not implemented")
                return nil
            }
        }

        func parseCSSValue(name: String, componentValues: [CSS.ComponentValue]) {
            let context = ParseContext(componentValues: componentValues, name: name)

            switch name {
            case "display":
                display.value = parseDisplay(context: context)
            case "background-color":
                backgroundColor.value = parseColor(context: context)
            case "color":
                color.value = parseColor(context: context)
            case "font-size":
                fontSize.value = parseFontSize(context: context)
            case "inset-block-start":
                insetBlockStart.value = parseLengthPercentageOrAuto(context: context)
            case "inset-inline-start":
                insetInlineStart.value = parseLengthPercentageOrAuto(context: context)
            case "inset-block-end":
                insetBlockEnd.value = parseLengthPercentageOrAuto(context: context)
            case "inset-inline-end":
                insetInlineEnd.value = parseLengthPercentageOrAuto(context: context)
            case "line-height":
                parseLineHeight(context: context)
            case "margin":
                parseMarginShortHand(context: context)
            case "margin-top":
                marginTop.value = parseMargin(context: context)
            case "margin-right":
                marginRight.value = parseMargin(context: context)
            case "margin-bottom":
                marginBottom.value = parseMargin(context: context)
            case "margin-left":
                marginLeft.value = parseMargin(context: context)
            case "padding":
                parsePaddingShortHand(context: context)
            case "padding-top":
                paddingTop.value = parsePadding(context: context)
            case "padding-right":
                paddingRight.value = parsePadding(context: context)
            case "padding-bottom":
                paddingBottom.value = parsePadding(context: context)
            case "padding-left":
                paddingLeft.value = parsePadding(context: context)
            case "top":
                top.value = parseLengthPercentageOrAuto(context: context)
            case "right":
                right.value = parseLengthPercentageOrAuto(context: context)
            case "bottom":
                bottom.value = parseLengthPercentageOrAuto(context: context)
            case "left":
                left.value = parseLengthPercentageOrAuto(context: context)
            case "width":
                width.value = parseWidth(context: context)
            case "height":
                height.value = parseHeight(context: context)
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
            let lineHeight = lineHeight.lineHeight()
            switch lineHeight {
            case .normal:
                return fontMeasurements.fontMetrics.lineHeight
            default:
                FIXME("lineHeight: \(lineHeight) not implemented, defaulting to normal")
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
