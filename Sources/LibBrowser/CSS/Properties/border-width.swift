extension CSS {
    enum BorderWidth: CustomStringConvertible {
        case lineWidth(LineWidth)
        case length(Dimension)

        var description: String {
            switch self {
            case let .lineWidth(lineWidth):
                "\(lineWidth)"
            case let .length(dimension):
                "\(dimension)"
            }
        }
    }

    static func parseBorderWidth(value: CSS.ComponentValue) -> BorderWidth {
        switch value {
        case let .token(.ident(ident)):
            .lineWidth(LineWidth(value: ident))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
        default:
            DIE("border-width value: \(value) not implemented")
        }
    }

    static func parseBorderWidth(context: ParseContext) -> Property<RectangularShorthand<BorderWidth>> {
        let result: ParseResult<RectangularShorthand<BorderWidth>> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        let value: PropertyValue<RectangularShorthand<BorderWidth>>
        switch declaration.count {
        case 1:
            value = .set(.one(parseBorderWidth(value: declaration[0])))
        case 2:
            value = .set(.two(
                topBottom: parseBorderWidth(value: declaration[0]),
                leftRight: parseBorderWidth(value: declaration[1])
            ))
        case 3:
            value = .set(.three(
                top: parseBorderWidth(value: declaration[0]),
                leftRight: parseBorderWidth(value: declaration[1]),
                bottom: parseBorderWidth(value: declaration[2])
            ))
        case 4:
            value = .set(.four(
                top: parseBorderWidth(value: declaration[0]),
                right: parseBorderWidth(value: declaration[1]),
                bottom: parseBorderWidth(value: declaration[2]),
                left: parseBorderWidth(value: declaration[3])
            ))
        default:
            FIXME("\(context.name) value: \(declaration) not implemented")
            value = .initial
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }
}
