
extension CSS {
    struct ParsedDeclaration {
        var componentValues: [ComponentValue]
        var count: Int {
            componentValues.count
        }

        var important = false

        subscript(index: Int) -> ComponentValue {
            componentValues[index]
        }
    }

    struct ParseResult<T> {
        var property: Property<T>?
        var declaration: ParsedDeclaration
    }

    struct ParseContext {
        var componentValues: [ComponentValue]
        var name: String

        func parseDeclaration() -> ParsedDeclaration {
            // parse important flag, from the end: !important
            let result = CSS.parseImportant(componentValues: componentValues)
            return ParsedDeclaration(
                componentValues: result.valuesWithoutImportant,
                important: result.important
            )
        }

        func parseGlobal<T>() -> ParseResult<T> {
            let declaration = parseDeclaration()
            var value: PropertyValue<T>?
            if declaration.count == 1 {
                switch declaration[0] {
                case .token(.ident("initial")):
                    value = .initial
                case .token(.ident("inherit")):
                    value = .inherit
                case .token(.ident("unset")):
                    value = .unset
                case .token(.ident("revert")):
                    value = .revert
                default:
                    break
                }
            }

            let property = if let value {
                Property(name: name, value: value, important: declaration.important)
            } else {
                nil as CSS.Property<T>?
            }
            return ParseResult(property: property, declaration: declaration)
        }
    }
}
