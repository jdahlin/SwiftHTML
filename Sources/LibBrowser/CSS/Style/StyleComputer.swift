import Foundation

import CoreText

extension CSS {
    struct StyleComputer {
        var styleSheets: [CSSOM.CSSStyleSheet] = []
        var document: DOM.Document!

        var rootElementFontMetrics: FontMetrics!
        lazy var defaultFontMetrics = FontMetrics(
            fontSize: CSS.Pixels(16.0),
            lineHeight: CSS.Pixels(16.0),
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
            if property.isRevert() {}
            if let value = property.value {
                style.setProperty(name: property.name, value: value)
            }
        }

        func cascadeDeclarations(
            style: inout StyleProperties,
            rules: [CSSOM.CSSStyleRule],
            cascadeOrigin _: CSS.CascadeOrigin,
            important: Bool
        ) {
            for rule in rules {
                let declaration = rule.declarations
                for property in declaration.propertyValues {
                    guard property.important == important else {
                        continue
                    }

                    if property.name == "all" {
                        print("\(#function): FIXME: set all")
                    }

                    setProperty(
                        style: &style,
                        property: property,
                        document: document,
                        declaration: declaration
                    )
                }
            }
        }

        func computeCascadedValues(style: inout StyleProperties, element: DOM.Element) {
            // First, we collect all the CSS rules whose selectors match `element`:
            let userAgentRules = collectMatchingRules(element: element, cascadeOrigin: .userAgent)
            let userRules = collectMatchingRules(element: element, cascadeOrigin: .user)
            let authorRules = collectMatchingRules(element: element, cascadeOrigin: .author)
            // FIXME: sort according to order and specificity

            // Then we resolve all the CSS custom properties ("variables") for this element:

            // Then we apply the declarations from the matched rules in cascade order:
            cascadeDeclarations(
                style: &style,
                rules: userAgentRules,
                cascadeOrigin: .userAgent,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                rules: userRules,
                cascadeOrigin: .user,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                rules: authorRules,
                cascadeOrigin: .author,
                important: false
            )

            // FIXME: Animations declarations [css-animations-1]

            cascadeDeclarations(
                style: &style,
                rules: userAgentRules,
                cascadeOrigin: .userAgent,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                rules: userRules,
                cascadeOrigin: .user,
                important: false
            )
            cascadeDeclarations(
                style: &style,
                rules: authorRules,
                cascadeOrigin: .author,
                important: false
            )

            // FIXME: Transition declarations [css-transitions-1]
        }

        mutating func computeStyle(element: DOM.Element) -> StyleProperties {
            var style = StyleProperties()

            // 1. Perform the cascade. This produces the "specified style"
            // TRY(compute_cascaded_values(style, element, pseudo_element, did_match_any_pseudo_element_rules, mode));
            computeCascadedValues(style: &style, element: element)

            // 2. Compute the math-depth property, since that might affect the font-size
            // compute_math_depth(style, &element, pseudo_element);

            // 3. Compute the font, since that may be needed for font-relative CSS units
            computeFont(style: &style, element: element)

            // 4. Absolutize values, turning font/viewport relative lengths into absolute lengths
            absolutizeValues(style: &style, element: element)

            // 5. Default the values, applying inheritance and 'initial' as needed
            computeDefaultedValues(style: &style, element: element)

            // 6. Run automatic box type transformations
            transformBoxTypeIfNeeded(style: &style, element: element)

            return style
        }

        func transformBoxTypeIfNeeded(style _: inout StyleProperties, element _: DOM.Element) {
            // FIXME: math, position: absolute/fixed or float, grid, flex
        }

        mutating func computeFont(style: inout StyleProperties, element: DOM.Element) {
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
                name: "font-size",
                value: .fontSize(.length(CSS.Length(number: pixelSize, unit: "px")))
            )
            style.setProperty(
                name: "line-height",
                value: .lineHeight(.normal)
            )

            style.setComputedFont(font: font)
            if element is HTML.HtmlElement {
                rootElementFontMetrics = calculateRootElementFontMetrics(style)
            }
        }

        func absolutizeValues(style: inout StyleProperties, element: DOM.Element) {
            let parentOrRootLineHeight = parentOrRootLineHeight(element: element)

            let fontPixelMetrics = style.computedFont!.pixelMetrics()

            var fontMetrics = FontMetrics(
                fontSize: rootElementFontMetrics.fontSize,
                lineHeight: parentOrRootLineHeight,
                pixelMetrics: fontPixelMetrics
            )
            let fontMeasurements = FontMeasurements(
                viewportRect: viewPortRect()!,
                fontMetrics: fontMetrics,
                rootFontMetrics: rootElementFontMetrics
            )

            let fontSize = style.fontSize.fontSize().length().toPx(fontMeasurements: fontMeasurements)
            fontMetrics.fontSize = fontSize

            if style.lineHeight.hasValue(),
               case let .lineHeight(.percentage(number)) = style.lineHeight.value
            {
                style.lineHeight.value = .lineHeight(.length(.absolute(.px(fontSize * number.toDouble()))))
            }
            let lineHeight = style.calculateLineHeight(fontMeasurements: fontMeasurements)
            fontMetrics.lineHeight = lineHeight

            if style.lineHeight.hasValue(),
               case .lineHeight(.length) = style.lineHeight.value
            {
                style.lineHeight.value = .lineHeight(.length(CSS.Length(number: lineHeight.toDouble(), unit: "px")))
            }
            for property in style {
                guard let value = property.value else { continue }
                let newValue = value.absolutized(fontMeasurements: fontMeasurements)
                // print("absolutizeValues: \(property.name) \(value) -> \(newValue)")
                style.setProperty(name: property.name, value: newValue)
            }
        }

        func computeDefaultedValues(style: inout StyleProperties, element: DOM.Element) {
            // Walk the list of all known CSS properties and:
            // - Add them to `style` if they are missing.
            // - Resolve `inherit` and `initial` as needed.
            for var property in style {
                computeDefaultedValue(style: &style, element: element, property: &property)
            }

            // https://www.w3.org/TR/css-color-4/#resolving-other-colors
            // In the color property, the used value of currentcolor is the inherited value.
            // FIXME: currentcolor
        }

        func getInheritValue(style _: StyleProperties, element: DOM.Element, property: StyleProperty) -> StyleValue? {
            if let parentElement = elementToInheritStyleFrom(element: element),
               let parentComputedCSSValues = parentElement.computedCSSValues
            {
                return parentComputedCSSValues.getProperty(name: property.name)?.value
            }
            return property.initial
        }

        func computeDefaultedValue(style: inout StyleProperties, element: DOM.Element, property: inout StyleProperty) {
            if !property.hasValue() {
                if property.inherited {
                    let value = getInheritValue(style: style, element: element, property: property)
                    style.setProperty(name: property.name, value: value)
                } else {
                    style.setProperty(name: property.name, value: property.initial)
                }
                return
            }

            switch property.value {
            case .initial:
                style.setProperty(name: property.name, value: property.initial)
            case .inherit:
                let value = getInheritValue(style: style, element: element, property: property)
                style.setProperty(name: property.name, value: value)
            case .unset where property.inherited:
                let value = getInheritValue(style: style, element: element, property: property)
                style.setProperty(name: property.name, value: value)
            case .unset where !property.inherited:
                style.setProperty(name: property.name, value: property.initial)
            default:
                break
            }
        }

        mutating func calculateRootElementFontMetrics(_ style: StyleProperties) -> FontMetrics {
            let rootValue = style.fontSize.fontSize()
            let fontPixelMetrics = style.computedFont!.pixelMetrics()
            var fontMetrics = FontMetrics(
                fontSize: defaultFontMetrics.fontSize,
                lineHeight: CSS.Pixels.nearestValueFor(fontPixelMetrics.lineSpacing()),
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

        func parentOrRootLineHeight(element: DOM.Element) -> CSS.Pixels {
            let parentElement = elementToInheritStyleFrom(element: element)
            guard let parentElement else {
                return rootElementFontMetrics.lineHeight
            }

            let computedValues = parentElement.computedCSSValues
            guard let computedValues else {
                return rootElementFontMetrics.lineHeight
            }

            let parentFontPixelMetrics = computedValues.computedFont!.pixelMetrics()
            let parentFontSize = computedValues.fontSize.fontSize()
            let parentFontSizeValue = if case .absolute = parentFontSize {
                parentFontSize.absoluteLengthToPx()
            } else {
                rootElementFontMetrics.fontSize
            }
            let parentParentLineHeight = parentOrRootLineHeight(element: parentElement)
            let parentFontMetrics = FontMetrics(
                fontSize: parentFontSizeValue,
                lineHeight: parentParentLineHeight,
                pixelMetrics: parentFontPixelMetrics
            )
            return computedValues.calculateLineHeight(fontMeasurements: FontMeasurements(
                viewportRect: viewPortRect()!,
                fontMetrics: parentFontMetrics,
                rootFontMetrics: rootElementFontMetrics
            ))
        }

        func collectMatchingRules(element: DOM.Element, cascadeOrigin: CSS.CascadeOrigin) -> [CSSOM.CSSStyleRule] {
            var rules: [CSSOM.CSSStyleRule] = []
            for sheet in styleSheets {
                guard sheet.cascadeOrigin == cascadeOrigin else { continue }
                for styleRule in sheet.styleRules {
                    guard styleRule.selector.match(element: element) else { continue }
                    rules.append(styleRule)
                }
            }

            return rules
        }
    }
}
