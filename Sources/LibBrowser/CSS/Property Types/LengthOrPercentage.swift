extension CSS {
    enum LengthOrPercentage: CustomStringConvertible, EnumStringInit {
        case length(Length)
        case percentage(Number)

        init(value: String) {
            if value.hasSuffix("%") {
                self = .percentage(.Number(Double(value.dropLast())!))
            } else if value.hasSuffix("px") {
                let number = Number(Double(value.dropLast(2))!)
                self = .length(Length(number: number, unit: "px"))
            } else {
                DIE("length-or-percentage: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case let .length(dimension):
                "\(dimension)"
            case let .percentage(number):
                "\(number)%"
            }
        }
    }

    enum LengthOrPercentageOrAuto: CustomStringConvertible {
        case length(Length)
        case percentage(Number)
        case auto

        var description: String {
            switch self {
            case let .length(length):
                "\(length)"
            case let .percentage(number):
                "\(number)%"
            case .auto:
                "auto"
            }
        }
    }

    static func parseLengthOrPercentage(propertyName: String, value: CSS.ComponentValue) -> LengthOrPercentage {
        switch value {
        case let .token(.percentage(number: number)):
            .percentage(number)
        case let .token(.number(number)):
            .length(Length(number: number, unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Length(number: number, unit: unit))
        default:
            DIE("\(propertyName) value: \(value) not implemented")
        }
    }

    static func parseLengthOrPercentageOrAuto(propertyName: String, value: CSS.ComponentValue) -> LengthOrPercentageOrAuto {
        switch value {
        case .token(.ident("auto")):
            return .auto
        case let .token(.percentage(number: number)):
            return .percentage(number)
        case let .token(.number(number)):
            return .length(Length(number: number, unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            return .length(Length(number: number, unit: unit))
        default:
            FIXME("\(propertyName) value: \(value) not implemented")
            return .auto
        }
    }

    static func parseLengthOrPercentage(context: ParseContext) -> Property<LengthOrPercentage> {
        let result: ParseResult<LengthOrPercentage> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        var value: PropertyValue<LengthOrPercentage> = .initial
        if declaration.count == 1 {
            value = .set(parseLengthOrPercentage(propertyName: context.name, value: declaration[0]))
        } else {
            FIXME("\(context.name) value: \(declaration) not implemented")
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }

    static func parseLengthOrPercentageOrAuto(context: ParseContext) -> Property<LengthOrPercentageOrAuto> {
        let result: ParseResult<LengthOrPercentageOrAuto> = context.parseGlobal()
        if let property = result.property {
            return property
        }
        let declaration = result.declaration
        var value: PropertyValue<LengthOrPercentageOrAuto> = .initial
        if declaration.count == 1 {
            value = .set(parseLengthOrPercentageOrAuto(propertyName: context.name, value: declaration[0]))
        } else {
            FIXME("\(context.name) value: \(declaration) not implemented")
        }
        return CSS.Property(name: context.name, value: value, important: declaration.important)
    }
}
