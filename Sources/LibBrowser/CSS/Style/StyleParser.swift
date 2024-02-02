
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

    struct ParseContext {
        var componentValues: [ComponentValue]
        var name: String

        func parseDeclaration() -> ParsedDeclaration {
            // parse important flag, from the end: !important
            let result = CSS.parseImportant(
                componentValues: componentValues.filter { $0 != .token(.whitespace) })
            return ParsedDeclaration(
                componentValues: result.valuesWithoutImportant,
                important: result.important
            )
        }

        func parseSingleIdent() -> String? {
            let result = parseIndentArray()
            guard !result.isEmpty else { return nil }
            return result[0]
        }

        func parseIndentArray() -> [String] {
            let declaration = parseDeclaration()
            return declaration.componentValues.compactMap {
                guard case let .token(.ident(ident)) = $0 else { return nil }
                return ident
            }
        }
    }
}
