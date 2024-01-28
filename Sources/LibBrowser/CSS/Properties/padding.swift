extension CSS {
    typealias Padding = LengthOrPercentage

    private static func parse(value: CSS.ComponentValue) -> Padding {
        switch value {
        case .token(.ident("auto")):
            .auto
        case let .token(.dimension(number: number, unit: unit)):
            .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
        default:
            DIE("padding value: \(value) not implemented")
        }
    }

    static func parsePadding(value: [CSS.ComponentValue]) -> Property<Padding> {
        guard value.count == 1 else {
            FIXME("padding value: \(value) not implemented")
            return .initial
        }
        return .set(parse(value: value[0]))
    }

    static func parsePaddingShorthand(value: [CSS.ComponentValue]) -> Property<RectangularShorthand<Padding>> {
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
            FIXME("padding value: \(value) not implemented")
        }
        return .initial
    }
}
