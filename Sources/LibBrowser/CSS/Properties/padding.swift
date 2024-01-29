extension CSS {
    typealias Padding = LengthOrPercentage

    private static func parse(value: CSS.ComponentValue) -> Padding {
        switch value {
        case let .token(.dimension(number: number, unit: unit)):
            .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
        default:
            DIE("padding value: \(value) not implemented")
        }
    }

    static func parsePadding(context: ParseContext) -> Property<Padding> {
        let declaration = context.parseDeclaration()
        let value: PropertyValue<Padding>
        if declaration.count == 1 {
            value = .set(parse(value: declaration[0]))
        } else {
            FIXME("padding value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }

    static func parsePaddingShorthand(context: ParseContext) -> Property<RectangularShorthand<Padding>> {
        let declaration = context.parseDeclaration()
        let value: PropertyValue<RectangularShorthand<Padding>>
        switch declaration.count {
        case 1:
            value = .set(.one(parse(value: declaration[0])))
        case 2:
            value = .set(.two(
                topBottom: parse(value: declaration[0]),
                leftRight: parse(value: declaration[1])
            ))
        case 3:
            value = .set(.three(
                top: parse(value: declaration[0]),
                leftRight: parse(value: declaration[1]),
                bottom: parse(value: declaration[2])
            ))
        case 4:
            value = .set(.four(
                top: parse(value: declaration[0]),
                right: parse(value: declaration[1]),
                bottom: parse(value: declaration[2]),
                left: parse(value: declaration[3])
            ))
        default:
            FIXME("padding value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }
}
