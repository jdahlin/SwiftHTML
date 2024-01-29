extension CSS {
    typealias Margin = LengthOrPercentage
    typealias PV = PropertyValue<RectangularShorthand<Margin>>

    private static func parse(value: CSS.ComponentValue) -> Margin {
        switch value {
        case .token(.ident("auto")):
            .auto
        case let .token(.dimension(number: number, unit: unit)):
            .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
        default:
            DIE("margin value: \(value) not implemented")
        }
    }

    static func parseMargin(context: ParseContext) -> Property<Margin> {
        let declaration = context.parseDeclaration()
        let value: PropertyValue<Margin>
        if declaration.count == 1 {
            value = .set(parse(value: declaration[0]))
        } else {
            FIXME("margin value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }

    static func parseMarginShorthand(context: ParseContext) -> Property<RectangularShorthand<Margin>> {
        let declaration = context.parseDeclaration()
        let value: PropertyValue<RectangularShorthand<Margin>>
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
            FIXME("margin value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }
}
