extension CSS {
    typealias Margin = LengthOrPercentageOrAuto
    typealias PV = PropertyValue<RectangularShorthand<Margin>>

    private static func parseMargin(value: CSS.ComponentValue) -> Margin {
        parseLengthOrPercentageOrAuto(propertyName: "margin", value: value)
    }

    static func parseMargin(context: ParseContext) -> Property<Margin> {
        let result: ParseResult<Margin> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<Margin>
        if declaration.count == 1 {
            value = .set(parseMargin(value: declaration[0]))
        } else {
            FIXME("\(context.name) value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }

    static func parseMarginShorthand(context: ParseContext) -> Property<RectangularShorthand<Margin>> {
        let result: ParseResult<RectangularShorthand<Margin>> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<RectangularShorthand<Margin>>
        switch declaration.count {
        case 1:
            value = .set(.one(parseMargin(value: declaration[0])))
        case 2:
            value = .set(.two(
                topBottom: parseMargin(value: declaration[0]),
                leftRight: parseMargin(value: declaration[1])
            ))
        case 3:
            value = .set(.three(
                top: parseMargin(value: declaration[0]),
                leftRight: parseMargin(value: declaration[1]),
                bottom: parseMargin(value: declaration[2])
            ))
        case 4:
            value = .set(.four(
                top: parseMargin(value: declaration[0]),
                right: parseMargin(value: declaration[1]),
                bottom: parseMargin(value: declaration[2]),
                left: parseMargin(value: declaration[3])
            ))
        default:
            FIXME("\(context.name) value: \(declaration) not implemented")
            value = .initial
        }
        return Property(name: context.name, value: value, important: declaration.important)
    }
}
