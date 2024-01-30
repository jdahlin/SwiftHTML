protocol EnumStringInit {
    init?(value: String)
}

extension CSS {
    static func parseEnum<T: EnumStringInit>(context: ParseContext) -> Property<T> {
        let result: ParseResult<T> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        var maybeValue: PropertyValue<T>?
        if declaration.count == 1, case let .token(.ident(ident)) = declaration[0] {
            if let enumInstance = T(value: ident) {
                maybeValue = .set(enumInstance)
            }
        }
        let value: PropertyValue<T> = if let maybeValue {
            maybeValue
        } else {
            .initial
        }

        return Property(name: context.name, value: value, important: declaration.important)
    }
}
