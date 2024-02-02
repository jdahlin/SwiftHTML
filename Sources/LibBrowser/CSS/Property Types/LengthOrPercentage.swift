extension CSS {
    enum LengthOrPercentage: CustomStringConvertible, EnumStringInit {
        case length(Length)
        case percentage(Number)

        static func zero() -> LengthOrPercentage {
            .length(.absolute(.px(.Integer(0))))
        }

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

        static func zero() -> LengthOrPercentageOrAuto {
            .length(.absolute(.px(.Integer(0))))
        }

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

    static func parseLengthOrPercentage(value: CSS.ComponentValue) -> LengthOrPercentage? {
        switch value {
        case let .token(.percentage(number: number)):
            .percentage(number)
        case let .token(.number(number)):
            .length(Length(number: number, unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Length(number: number, unit: unit))
        default:
            nil
        }
    }

    static func parseLengthOrPercentageOrAuto(value: CSS.ComponentValue) -> LengthOrPercentageOrAuto? {
        switch value {
        case .token(.ident("auto")):
            .auto
        case let .token(.percentage(number: number)):
            .percentage(number)
        case let .token(.number(number)):
            .length(Length(number: number, unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Length(number: number, unit: unit))
        default:
            nil
        }
    }
}
