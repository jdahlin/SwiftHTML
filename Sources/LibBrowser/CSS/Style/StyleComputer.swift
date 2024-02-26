import Foundation

import CoreText

extension CSS {
    struct StyleComputer {
        var styleSheets: [CSSOM.CSSStyleSheet] = []
        var document: DOM.Document!

        var rootElementFontMetrics: FontMetrics!
        lazy var defaultFontMetrics = FontMetrics(
            fontSize: CSS.Pixels(16.0),
            pixelMetrics: CTFont.defaultFont.pixelMetrics()
        )

        mutating func addFromDocument(document: DOM.Document) {
            let defaultStyleSheet = CSSOM.CSSStyleSheet(
                type: "text/css",
                cascadeOrigin: CSS.CascadeOrigin.userAgent
            )

            let defaultStyleSheetFilename = FileManager.default.currentDirectoryPath + "/Resources/CSS/default.css"
            let content: String
            do {
                content = try String(contentsOfFile: defaultStyleSheetFilename)
            } catch {
                fatalError("Failed to read \(defaultStyleSheetFilename): \(error)")
            }
            defaultStyleSheet.loadRules(content: content)
            self.document = document

            // FIXME: Support multiple documents, hashable documents
            styleSheets.append(contentsOf: [defaultStyleSheet] + document.styleSheets.styleSheets)
        }

        func setProperty(
            style: inout StyleProperties,
            property: CSS.StyleProperty,
            document _: DOM.Document,
            declaration _: CSSOM.CSSStyleDeclaration
        ) {
            if property.isRevert() {
                FIXME("revert")
            }
            style.setProperty(id: property.id, value: property.value)
        }

        func cascadeDeclarations(
            style: inout StyleProperties,
            element _: DOM.Element,
            rules: [CSSOM.CSSStyleRule],
            cascadeOrigin _: CSS.CascadeOrigin,
            important: Bool
        ) {
            var properties: [(CSS.StyleProperty, CSSOM.CSSStyleDeclaration)] = []
            for rule in rules {
                let declaration = rule.declarations
                // print(element, declaration.propertyValues.toStringDict())
                for property in declaration.propertyValues {
                    properties.append((property, declaration))
                }
            }

            // if properties.count > 0 {
            //     print("cascadeDeclarations: \(element) \(cascadeOrigin) \(important) \(properties)")
            // }

            for (property, declaration) in properties {
                guard property.important == important else {
                    continue
                }

                if property.id == .all {
                    print("\(#function): FIXME: set all")
                    continue
                }

//                print("\(element): \(property.id)=\(property.value) \(cascadeOrigin)")
                setProperty(
                    style: &style,
                    property: property,
                    document: document,
                    declaration: declaration
                )
            }
        }

        func computeCascadedValues(style: inout StyleProperties, element: DOM.Element) {
            // print("\(#function): \(element)")

            // First, we collect all the CSS rules whose selectors match `element`:
            let userAgentRules = collectMatchingRules(element: element, cascadeOrigin: .userAgent)
            let userRules = collectMatchingRules(element: element, cascadeOrigin: .user)
            let authorRules = collectMatchingRules(element: element, cascadeOrigin: .author)
            // FIXME: sort according to order and specificity
            // Then we resolve all the CSS custom properties ("variables") for this element:
            // print("rules: agent: \(userAgentRules.count) user: \(userRules.count) author: \(authorRules.count)")

            // Then we apply the declarations from the matched rules in cascade order:
            cascadeDeclarations(
                style: &style,
                element: element,
                rules: userAgentRules,
                cascadeOrigin: .userAgent,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                element: element,
                rules: userRules,
                cascadeOrigin: .user,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                element: element,
                rules: authorRules,
                cascadeOrigin: .author,
                important: false
            )

            // FIXME: Animations declarations [css-animations-1]

            cascadeDeclarations(
                style: &style,
                element: element,
                rules: userAgentRules,
                cascadeOrigin: .userAgent,
                important: true
            )
            cascadeDeclarations(
                style: &style,
                element: element,
                rules: userRules,
                cascadeOrigin: .user,
                important: true
            )
            cascadeDeclarations(
                style: &style,
                element: element,
                rules: authorRules,
                cascadeOrigin: .author,
                important: true
            )

            // FIXME: Transition declarations [css-transitions-1]
        }

        mutating func computeStyle(element: DOM.Element?) -> StyleProperties {
            var style = StyleProperties()

            // 1. Perform the cascade. This produces the "specified style"
            if let element {
                computeCascadedValues(style: &style, element: element)
            }

            // 2. Compute the math-depth property, since that might affect the font-size
            // compute_math_depth(style, &element, pseudo_element);

            // 3. Compute the font, since that may be needed for font-relative CSS units
            computeFont(style: &style, element: element)

            // 4. Absolutize values, turning font/viewport relative lengths into absolute lengths
            absolutizeValues(style: &style, element: element)

            // 5. Default the values, applying inheritance and 'initial' as needed
            computeDefaultedValues(style: &style, element: element)

            // 6. Run automatic box type transformations
            if let element {
                transformBoxTypeIfNeeded(style: &style, element: element)
            }
            return style
        }

        func transformBoxTypeIfNeeded(style _: inout StyleProperties, element _: DOM.Element) {
            // FIXME: math, position: absolute/fixed or float, grid, flex
        }

        mutating func computeFont(style: inout StyleProperties, element: DOM.Element?) {
            // FIXME: Compute default using initial/inherit etc
            // let fontSize = style.fontSize.fontSize()

            // FIXME: Parse CSS property
            let fontFamily = "serif"
            // FIXME: Parse CSS property
            // let fontStyle = "normal"
            // // FIXME: Parse CSS property
            // let fontWeight = "normal"

            // FIXME: Use computed values
            let font = CTFontCreateWithName(fontFamily as CFString, 14.0, nil)

            let pixelSize = CTFontGetSize(font)

            style.setProperty(
                id: .fontSize,
                value: .fontSize(.length(CSS.Length(number: pixelSize, unit: "px")))
            )
            style.setProperty(
                id: .lineHeight,
                value: .lineHeight(.normal)
            )

            style.setComputedFont(font: font)
            if element is HTML.HtmlElement {
                rootElementFontMetrics = calculateRootElementFontMetrics(style)
            }
        }

        func absolutizeValues(style: inout StyleProperties, element _: DOM.Element?) {
            let fontPixelMetrics = style.computedFont!.pixelMetrics()

            var fontMetrics = FontMetrics(
                fontSize: rootElementFontMetrics.fontSize,
                pixelMetrics: fontPixelMetrics
            )
            let fontMeasurements = FontMeasurements(
                viewportRect: viewPortRect()!,
                fontMetrics: fontMetrics,
                rootFontMetrics: rootElementFontMetrics
            )

            let fontSize = style.fontSize!.length().toPx(fontMeasurements: fontMeasurements)
            fontMetrics.fontSize = fontSize

            if case let .percentage(percentage) = style.lineHeight {
                style.lineHeight = CSS.LineHeight(.length(.absolute(.px(fontSize * percentage.asFraction()))))
            }
            let lineHeight = style.calculateLineHeight(fontMeasurements: fontMeasurements)
            fontMetrics.lineHeight = lineHeight

            if case .length = style.lineHeight {
                FIXME("set lineHeight")
            }
            for property in style {
                guard property.resolved() else { continue }

                let newValue = property.value.absolutized(fontMeasurements: fontMeasurements)
                // print("absolutizeValues: \(property.id) \(value) -> \(newValue)")
                style.setProperty(id: property.id, value: newValue)
            }
        }

        func computeDefaultedValues(style: inout StyleProperties, element: DOM.Element?) {
            // Walk the list of all known CSS properties and:
            // - Add them to `style` if they are missing.
            // - Resolve `inherit` and `initial` as needed.
            for var property in style {
                computeDefaultedPropertyValue(style: &style, element: element, property: &property)
            }

            // https://www.w3.org/TR/css-color-4/#resolving-other-colors
            // In the color property, the used value of currentcolor is the inherited value.
            if case .currentColor = style.color {
                let color = getInheritValue(style: style, element: element, property: style.$color)
                if let color {
                    style.setProperty(id: .color, value: color)
                }
            }
        }

        func getInheritValue(style _: StyleProperties, element: DOM.Element?, property: StyleProperty) -> StyleValue? {
            if let parentElement = elementToInheritStyleFrom(element: element),
               let parentComputedCSSValues = parentElement.computedCSSValues
            {
                return parentComputedCSSValues.getProperty(id: property.id)?.value
            }
            return property.initial
        }

        func computeDefaultedPropertyValue(style: inout StyleProperties, element: DOM.Element?, property: inout StyleProperty) {
            if case .unresolved = property.value {
                if property.inherited {
                    if let value = getInheritValue(style: style, element: element, property: property) {
                        style.setProperty(id: property.id, value: value)
                    }
                } else {
                    style.setProperty(id: property.id, value: property.initial)
                }
                return
            }

            switch property.value {
            case .initial:
                style.setProperty(id: property.id, value: property.initial)
            case .inherit:
                if let value = getInheritValue(style: style, element: element, property: property) {
                    style.setProperty(id: property.id, value: value)
                }
            case .unset where property.inherited:
                if let value = getInheritValue(style: style, element: element, property: property) {
                    style.setProperty(id: property.id, value: value)
                }
            case .unset where !property.inherited:
                style.setProperty(id: property.id, value: property.initial)
            default:
                break
            }
        }

        mutating func calculateRootElementFontMetrics(_ style: StyleProperties) -> FontMetrics {
            let rootValue = style.fontSize!
            let fontPixelMetrics = style.computedFont!.pixelMetrics()
            var fontMetrics = FontMetrics(
                fontSize: defaultFontMetrics.fontSize,
                pixelMetrics: fontPixelMetrics
            )
            let fontMeasurements = FontMeasurements(
                viewportRect: viewPortRect()!,
                fontMetrics: fontMetrics,
                rootFontMetrics: fontMetrics
            )
            fontMetrics.fontSize = rootValue.length().toPx(fontMeasurements: fontMeasurements)
            fontMetrics.lineHeight = style.calculateLineHeight(fontMeasurements: fontMeasurements)
            return fontMetrics
        }

        func elementToInheritStyleFrom(element: DOM.Element?) -> DOM.Element? {
            // let parentElement: DOM.Element?
            // if pseudoElement != nil {
            // parentElement = element

            element?.parentOrShadowHostElement()
        }

        func viewPortRect() -> CSS.PixelRect? {
            if let navigable = document.navigable {
                return navigable.viewportRect()
            }
            return nil
        }

        func collectMatchingRules(element: DOM.Element?, cascadeOrigin: CSS.CascadeOrigin) -> [CSSOM.CSSStyleRule] {
            var rules: [CSSOM.CSSStyleRule] = []
            guard let element else { return rules }

            for sheet in styleSheets {
                guard sheet.cascadeOrigin == cascadeOrigin else { continue }
                for styleRule in sheet.styleRules {
                    guard styleRule.selector.match(element: element) else { continue }
                    rules.append(styleRule)
                }
            }

            return rules
        }

        mutating func createDocumentStyle() -> StyleProperties {
            var style = StyleProperties()
            computeFont(style: &style, element: nil)
            computeDefaultedValues(style: &style, element: nil)
            absolutizeValues(style: &style, element: nil)
            let viewPort = viewPortRect()!
            style.width = CSS.Size(pixels: viewPort.width)
            style.height = CSS.Size(pixels: viewPort.height)
            style.display = CSS.Display(short: .block)
            return style
        }
    }
}
