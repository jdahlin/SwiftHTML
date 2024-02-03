import AppKit

extension CSS {
    class StyleProperties {
        lazy var display: StyleProperty = .init(id: .display, initial: .display(CSS.Display(outer: .inline, inner: .flow)))
        lazy var fontSize: StyleProperty = .init(id: .fontSize, initial: .fontSize(.absolute(.medium)), inherited: true)
        lazy var lineHeight: StyleProperty = .init(id: .lineHeight, initial: .fontSize(.absolute(.medium)), inherited: true)
        lazy var marginTop: StyleProperty = .init(id: .marginTop, initial: .margin(.zero()))
        lazy var marginRight: StyleProperty = .init(id: .marginRight, initial: .margin(.zero()))
        lazy var marginBottom: StyleProperty = .init(id: .marginBottom, initial: .margin(.zero()))
        lazy var marginLeft: StyleProperty = .init(id: .marginLeft, initial: .margin(.zero()))
        lazy var paddingTop: StyleProperty = .init(id: .paddingTop, initial: .padding(.zero()))
        lazy var paddingRight: StyleProperty = .init(id: .paddingRight, initial: .padding(.zero()))
        lazy var paddingBottom: StyleProperty = .init(id: .paddingBottom, initial: .padding(.zero()))
        lazy var paddingLeft: StyleProperty = .init(id: .paddingLeft, initial: .padding(.zero()))

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
            case .token(.ident("initial")):
                .initial
            case .token(.ident("inherit")):
                .inherit
            case .token(.ident("unset")):
                .unset
            case .token(.ident("revert")):
                .revert
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
            case .display:
                display.value = value
            case .fontSize:
                fontSize.value = value
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
            default:
                FIXME("setProperty: \(id) not implemented")
            }
        }

        func getProperty(id: PropertyID) -> StyleProperty? {
            switch id {
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
            default:
                FIXME("getProperty: \(id) not implemented")
                return nil
            }
        }

        func parseCSSValue(name: String, componentValues: [CSS.ComponentValue]) {
            let context = ParseContext(componentValues: componentValues, name: name)

            switch name {
            case "display":
                parseDisplay(context: context)
            case "line-height":
                parseLineHeight(context: context)
            case "margin":
                parseMarginShortHand(context: context)
            case "margin-top":
                if let value = parseMargin(context: context) {
                    marginTop.value = value
                }
            case "margin-right":
                if let value = parseMargin(context: context) {
                    marginRight.value = value
                }
            case "margin-bottom":
                if let value = parseMargin(context: context) {
                    marginBottom.value = value
                }
            case "margin-left":
                if let value = parseMargin(context: context) {
                    marginLeft.value = value
                }
            case "padding":
                parsePaddingShortHand(context: context)
            case "padding-top":
                if let value = parsePadding(context: context) {
                    paddingTop.value = value
                }
            case "padding-right":
                if let value = parsePadding(context: context) {
                    paddingRight.value = value
                }
            case "padding-bottom":
                if let value = parsePadding(context: context) {
                    paddingBottom.value = value
                }
            case "padding-left":
                if let value = parsePadding(context: context) {
                    paddingLeft.value = value
                }
            default:
                FIXME("parseCSSValue: \(name) not implemented")
            }
        }

        func toStringDict() -> [String: String] {
            var dict: [String: String] = [:]
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if let property = child.value as? StyleProperty {
                    dict["\(property.id)"] = "\(property.value!)"
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
