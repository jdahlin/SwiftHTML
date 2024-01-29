import Foundation

extension CSS {
    struct StyleComputer {
        var styleSheets: [CSSOM.CSSStyleSheet] = []

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

            // FIXME: Support multiple documents, hashable documents
            styleSheets.append(contentsOf: [defaultStyleSheet] + document.styleSheets.styleSheets)
        }

        func computeStyles(element: DOM.Element) {
            guard let ownerDocument = element.ownerDocument else {
                print("ELEMENT missing owner", element)
                return
            }
            // guard let documentStyleSheets = styleSheets[ownerDocument] else {
            //     print("No stylessheets for doc :(", ownerDocument)
            //     return
            // }
            var propertyMap: [String: [AnySetProperty]] = [:]
            for sheet in styleSheets {
                getPropertiesForElement(propertyMap: &propertyMap, sheet: sheet, element: element)
            }

            for (name, properties) in propertyMap {
                print(name, properties)
            }
        }

        func getPropertiesForElement(propertyMap: inout [String: [AnySetProperty]],
                                     sheet: CSSOM.CSSStyleSheet,
                                     element: DOM.Element)
        {
            for rule in sheet.cssRules {
                guard let styleRule = rule as? CSSOM.CSSStyleRule else {
                    continue
                }
                let selector = CSS.Selector(selectors: styleRule.selectorList)
                if selector.match(element: element), styleRule.declarations.properties.count > 0 {
                    for property in styleRule.declarations.propertyValues.fetchSetProperties() {
                        propertyMap[property.name, default: []].append(property.property)
                    }
                }
            }
        }
    }
}
