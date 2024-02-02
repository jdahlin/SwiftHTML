// [Exposed=Window]
// interface CSSStyleDeclaration {
//   CSSOMString getPropertyPriority(CSSOMString property);
//   [CEReactions] undefined setProperty(CSSOMString property, [LegacyNullToEmptyString] CSSOMString value, optional [LegacyNullToEmptyString] CSSOMString priority = "");
//   [CEReactions] CSSOMString removeProperty(CSSOMString property);
//   readonly attribute CSSRule? parentRule;
//   [CEReactions] attribute [LegacyNullToEmptyString] CSSOMString cssFloat;
// };

extension CSSOM {
    class CSSStyleDeclaration {
        var properties: [String: String] {
            propertyValues.toStringDict()
        }

        var propertyValues = CSS.StyleProperties()
        init(items: [CSS.Item]) {
            for item in items {
                switch item {
                case let .declaration(declaration):
                    switch declaration.name {
                    case let .token(.ident(name)):
                        propertyValues.parseCSSValue(name: name, componentValues: declaration.value)
                    default:
                        FIXME("declaration name: \(declaration.name) not implemented")
                    }
                default:
                    FIXME("\(item): not implemented")
                }
            }
        }

        // readonly attribute unsigned long length;
        var length: UInt {
            UInt(properties.count)
        }

        // CSSOMString getPropertyValue(CSSOMString property);
        func getPropertyValue(property: String) -> String? {
            properties[property]
        }

        // getter CSSOMString item(unsigned long index);
        func item(index: UInt) -> String? {
            guard index < length else {
                return nil
            }
            return properties[Array(properties.keys)[Int(index)]]
        }

        // [CEReactions] attribute CSSOMString cssText;
        var cssText: String {
            properties.map { "\($0.key): \($0.value);" }.joined(separator: " ")
        }
    }
}
