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
            for item in items {
                switch item {
                case let .declaration(declaration):
                    let name = switch declaration.name {
                    case let .token(.ident(name)): name
                    default:
                        DIE("declaration name: \(declaration.name) not implemented")
                    }
                    if let value = parseCSSValue(name: name, value: declaration.value) {
                        properties[name] = value
                    }
                default:
                    DIE("\(item): not implemented")
                }
            }
        }
    }
}

func parseCSSValue(name: String, value: [CSS.ComponentValue]) -> String? {
    switch name {
    case "background-color", "color":
        let color = parseColor(value: value)
        return "\(color)"
    case "margin", "padding":
        if let dimension = parseDimension(value: value) {
            return "\(dimension)"
        }
        return nil
    default:
        FIXME("\(name): \(value) not implemented")
        return nil
    }
}

func parseColor(value: [CSS.ComponentValue]) -> CSS.Color {
    switch value[0] {
    case let .token(.ident(name)):
        CSS.Color.named(CSS.Color.Named(string: name))
    default:
        DIE("color value: \(value) not implemented")
    }
}

func parseDimension(value: [CSS.ComponentValue]) -> CSS.Number? {
    switch value.count {
    case 1:
        switch value[0] {
        case let .token(.dimension(number: number)):
            return number.number
        default:
            break
        }
    default:
        break
    }
    FIXME("dimension value: \(value) not implemented")
    return nil
}
