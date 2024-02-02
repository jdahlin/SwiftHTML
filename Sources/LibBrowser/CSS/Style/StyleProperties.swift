import AppKit

extension CSS {
    class StyleProperties {
        lazy var display: StyleProperty = .init(name: "display", value: .display(CSS.Display(outer: .inline, inner: .flow)))
        lazy var fontSize: StyleProperty = .init(name: "font-size", value: .fontSize(.absolute(.medium)))
        lazy var lineHeight: StyleProperty = .init(name: "line-height", value: .fontSize(.absolute(.medium)))
        lazy var paddingBottom: StyleProperty = .init(name: "padding-bottom", value: .padding(.zero()))
        lazy var paddingLeft: StyleProperty = .init(name: "padding-left", value: .padding(.zero()))
        lazy var paddingRight: StyleProperty = .init(name: "padding-right", value: .padding(.zero()))
        lazy var paddingTop: StyleProperty = .init(name: "padding-top", value: .padding(.zero()))
        lazy var marginBottom: StyleProperty = .init(name: "margin-bottom", value: .margin(.zero()))
        lazy var marginLeft: StyleProperty = .init(name: "margin-left", value: .margin(.zero()))
        lazy var marginRight: StyleProperty = .init(name: "margin-right", value: .margin(.zero()))
        lazy var marginTop: StyleProperty = .init(name: "margin-top", value: .margin(.zero()))

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

        func setProperty(property: StyleProperty) {
            switch property.name {
            case "display":
                display = property
            case "font-size":
                fontSize = property
            case "line-height":
                lineHeight = property
            case "margin-bottom":
                marginBottom = property
            case "margin-left":
                marginLeft = property
            case "margin-right":
                marginRight = property
            case "margin-top":
                marginTop = property
            case "padding-bottom":
                paddingBottom = property
            case "padding-left":
                paddingLeft = property
            case "padding-right":
                paddingRight = property
            case "padding-top":
                paddingTop = property
            default:
                FIXME("setProperty: \(property.name) not implemented")
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
                    dict[property.name] = "\(property.value)"
                }
            }
            return dict
        }

        func setComputedFont(font: CTFont) {
            computedFont = font
        }

        func calculateLineHeight(viewPortRect _: CSS.PixelRect?,
                                 fontMetrics: FontMetrics,
                                 rootFontMetrics _: FontMetrics) -> CSS.Pixels
        {
            let lineHeight = lineHeight.lineHeight()
            switch lineHeight {
            case .normal:
                return fontMetrics.lineHeight
            default:
                FIXME("lineHeight: \(lineHeight) not implemented, defaulting to normal")
                return fontMetrics.lineHeight
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
