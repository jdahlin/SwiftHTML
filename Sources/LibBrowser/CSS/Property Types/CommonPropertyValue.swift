extension CSS {
    enum RectangularShorthand<T>: CustomStringConvertible {
        case one(T)
        case two(topBottom: T, leftRight: T)
        case three(top: T, leftRight: T, bottom: T)
        case four(top: T, right: T, bottom: T, left: T)

        var description: String {
            switch self {
            case let .one(value):
                "\(value)"
            case let .two(topBottom, leftRight):
                "\(topBottom) \(leftRight)"
            case let .three(top, leftRight, bottom):
                "\(top) \(leftRight) \(bottom)"
            case let .four(top, right, bottom, left):
                "\(top) \(right) \(bottom) \(left)"
            }
        }
    }

    static func parseColor(context: ParseContext) -> CSS.Property<CSS.Color> {
        let result: ParseResult<CSS.Color> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration

        let value: PropertyValue<Color> = if declaration.count == 1,
                                             case let .token(.ident(name)) = declaration[0]
        {
            .set(CSS.Color.named(CSS.Color.Named(string: name)))
        } else {
            .initial
        }

        return CSS.Property(
            name: context.name,
            value: value,
            important: declaration.important,
            caseSensitive: true
        )
    }
}
