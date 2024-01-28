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

    static func parseBorderWidth(value: [CSS.ComponentValue]) -> CSS.Property<RectangularShorthand<BorderWidth>> {
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
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("border-width value: \(value) not implemented")
        }
        return .initial
    }
}
