extension CSS {
    typealias Padding = LengthOrPercentage

    static func parsePadding(value: CSS.ComponentValue) -> Padding {
        switch value {
        case let .token(.dimension(number: number, unit: unit)):
            .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
        default:
            DIE("padding value: \(value) not implemented")
        }
    }

    static func parsePadding(context: ParseContext) -> Property<Padding> {
        let result: ParseResult<Padding> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<Padding>
        if declaration.count == 1 {
            value = .set(parsePadding(value: declaration[0]))
        } else {
            FIXME("padding value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }

    static func parsePaddingShorthand(context: ParseContext) -> Property<RectangularShorthand<Padding>> {
        let result: ParseResult<RectangularShorthand<Padding>> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<RectangularShorthand<Padding>>
        switch declaration.count {
        case 1:
            value = .set(.one(parsePadding(value: declaration[0])))
        case 2:
            value = .set(.two(
                topBottom: parsePadding(value: declaration[0]),
                leftRight: parsePadding(value: declaration[1])
            ))
        case 3:
            value = .set(.three(
                top: parsePadding(value: declaration[0]),
                leftRight: parsePadding(value: declaration[1]),
                bottom: parsePadding(value: declaration[2])
            ))
        case 4:
            value = .set(.four(
                top: parsePadding(value: declaration[0]),
                right: parsePadding(value: declaration[1]),
                bottom: parsePadding(value: declaration[2]),
                left: parsePadding(value: declaration[3])
            ))
        default:
            FIXME("\(context.name) value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }
}
