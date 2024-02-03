import AppKit

extension CSS {
    class StyleProperties {
        lazy var display: StyleProperty = .init(name: "display", initial: .display(CSS.Display(outer: .inline, inner: .flow)))
        lazy var fontSize: StyleProperty = .init(name: "font-size", initial: .fontSize(.absolute(.medium)), inherited: true)
        lazy var lineHeight: StyleProperty = .init(name: "line-height", initial: .fontSize(.absolute(.medium)), inherited: true)
        lazy var paddingBottom: StyleProperty = .init(name: "padding-bottom", initial: .padding(.zero()))
        lazy var paddingLeft: StyleProperty = .init(name: "padding-left", initial: .padding(.zero()))
        lazy var paddingRight: StyleProperty = .init(name: "padding-right", initial: .padding(.zero()))
        lazy var paddingTop: StyleProperty = .init(name: "padding-top", initial: .padding(.zero()))
        lazy var marginBottom: StyleProperty = .init(name: "margin-bottom", initial: .margin(.zero()))
        lazy var marginLeft: StyleProperty = .init(name: "margin-left", initial: .margin(.zero()))
        lazy var marginRight: StyleProperty = .init(name: "margin-right", initial: .margin(.zero()))
        lazy var marginTop: StyleProperty = .init(name: "margin-top", initial: .margin(.zero()))

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

        func setProperty(name: String, value: StyleValue?) {
            switch name {
            case "display":
                display.value = value
            case "font-size":
                fontSize.value = value
            case "line-height":
                lineHeight.value = value
            case "margin-bottom":
                marginBottom.value = value
            case "margin-left":
                marginLeft.value = value
            case "margin-right":
                marginRight.value = value
            case "margin-top":
                marginTop.value = value
            case "padding-bottom":
                paddingBottom.value = value
            case "padding-left":
                paddingLeft.value = value
            case "padding-right":
                paddingRight.value = value
            case "padding-top":
                paddingTop.value = value
            default:
                FIXME("setProperty: \(name) not implemented")
            }
        }

        func getProperty(name: String) -> StyleProperty? {
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if let propertyName = child.label, propertyName == name {
                    return child.value as? StyleProperty
                }
            }
            return nil
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
                    dict[property.name] = "\(property.value!)"
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
