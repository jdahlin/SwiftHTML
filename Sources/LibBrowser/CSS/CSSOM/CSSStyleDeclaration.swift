// [Exposed=Window]
// interface CSSStyleDeclaration {
//   [CEReactions] attribute CSSOMString cssText;
//   readonly attribute unsigned long length;
//   getter CSSOMString item(unsigned long index);
//   CSSOMString getPropertyValue(CSSOMString property);
//   CSSOMString getPropertyPriority(CSSOMString property);
//   [CEReactions] undefined setProperty(CSSOMString property, [LegacyNullToEmptyString] CSSOMString value, optional [LegacyNullToEmptyString] CSSOMString priority = "");
//   [CEReactions] CSSOMString removeProperty(CSSOMString property);
//   readonly attribute CSSRule? parentRule;
//   [CEReactions] attribute [LegacyNullToEmptyString] CSSOMString cssFloat;
// };

extension CSSOM {
    class CSSStyleDeclaration {
        var properties: [String: String] = [:]

        init(items: [CSS.Item]) {
            var propertyValues = CSS.PropertyValues()
            for item in items {
                switch item {
                case let .declaration(declaration):
                    switch declaration.name {
                    case let .token(.ident(name)):
                        propertyValues.parseCSSValue(name: name, value: declaration.value)
                    default:
                        FIXME("declaration name: \(declaration.name) not implemented")
                    }
                default:
                    FIXME("\(item): not implemented")
                }
            }
            print(propertyValues)
        }
    }
}
