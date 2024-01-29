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

    static func parseBorderWidth(context: ParseContext) -> Property<RectangularShorthand<BorderWidth>> {
        let declaration = context.parseDeclaration()
        func parse(value: CSS.ComponentValue) -> BorderWidth {
            switch value {
            case let .token(.ident(ident)):
                .lineWidth(LineWidth(value: ident))
            case let .token(.dimension(number: number, unit: unit)):
                .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
            default:
                DIE("border-width value: \(value) not implemented")
            }
        }
        var value: PropertyValue<RectangularShorthand<BorderWidth>>
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
            FIXME("border-width value: \(declaration) not implemented")
            value = .initial
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }
}
