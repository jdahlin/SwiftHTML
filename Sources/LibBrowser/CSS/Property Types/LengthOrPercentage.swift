extension CSS {
    enum LengthOrPercentage: CustomStringConvertible, EnumStringInit, Equatable {
        case length(Length)
        case percentage(Percentage)

        static func zero() -> LengthOrPercentage {
            .length(.absolute(.px(0)))
        }

        init(value: String) {
            if value.hasSuffix("%") {
                self = .percentage(Percentage(Double(value.dropLast())!))
            } else if value.hasSuffix("px") {
                let number = Double(value.dropLast(2))!
                self = .length(Length(number: number, unit: "px"))
            } else {
                DIE("length-or-percentage: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case let .length(length):
                "\(length)"
            case let .percentage(number):
                "\(number)%"
            }
        }

        func pixels() -> CSS.Pixels {
            switch self {
            case let .length(length):
                return length.absoluteLengthToPx()
            case .percentage:
                FIXME("LengthOrPercentage resolve percentage")
                return CSS.Pixels(0)
            }
        }

        func resolved(layoutNode _: Layout.Node, referenceValue: CSS.Pixels) -> CSS.Length {
            switch self {
            case let .length(length):
                length
            case let .percentage(percentage):
                .absolute(.px(percentage.asFraction() * referenceValue.toDouble()))
            }
        }

        func toPx(layoutNode: Layout.Node, referenceValue: CSS.Pixels) -> CSS.Pixels {
            resolved(layoutNode: layoutNode, referenceValue: referenceValue).toPx(layoutNode: layoutNode)
        }
    }

    enum LengthOrPercentageOrAuto: CustomStringConvertible, Equatable {
        case length(Length)
        case percentage(Percentage)
        case auto

        static func zero() -> LengthOrPercentageOrAuto {
            .length(.absolute(.px(0)))
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

        func toPx(layoutNode: Layout.Node, referenceValue: CSS.Pixels) -> CSS.Pixels {
            resolved(layoutNode: layoutNode, referenceValue: referenceValue).toPx(layoutNode: layoutNode)
        }

        func toPx(layoutNode: Layout.Node) -> CSS.Pixels {
            switch self {
            case let .length(length):
                length.toPx(layoutNode: layoutNode)
            default:
                // FIXME("LengthOrPercentageOrAuto toPx")
                CSS.Pixels(0)
            }
        }

        func resolved(layoutNode _: Layout.Node, referenceValue: CSS.Pixels) -> Layout.AutoOr<CSS.Length> {
            switch self {
            case let .length(length):
                .value(length)
            case let .percentage(percentage):
                .value(.absolute(.px(percentage.asFraction() * referenceValue.toDouble())))
            case .auto:
                .value(CSS.Length(0))
            }
        }

        func pixels() -> CSS.Pixels {
            switch self {
            case let .length(length):
                return length.absoluteLengthToPx()
            case .percentage:
                FIXME("LengthOrPercentage resolve percentage")
                return CSS.Pixels(0)
            case .auto:
                // FIXME("LengthOrPercentage resolve auto")
                return CSS.Pixels(0)
            }
        }
    }

    static func parseLengthOrPercentage(value: CSS.ComponentValue) -> StyleValue? {
        switch value {
        case let .token(.percentage(number: number)):
            .percentage(number)
        case let .token(.number(number)):
            .length(Length(number: number.toDouble(), unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Length(number: number.toDouble(), unit: unit))
        default:
            nil
        }
    }

    static func parseLengthOrPercentageOrAuto(value: CSS.ComponentValue) -> StyleValue? {
        switch value {
        case .token(.ident("auto")):
            .auto
        case let .token(.percentage(number: number)):
            .percentage(number)
        case let .token(.number(number)):
            .length(Length(number: number.toDouble(), unit: "px"))
        case let .token(.dimension(number: number, unit: unit)):
            .length(Length(number: number.toDouble(), unit: unit))
        default:
            nil
        }
    }
}

extension CSS.StyleProperties {
    func parseLengthPercentageOrAuto(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        if let value = CSS.parseLengthOrPercentageOrAuto(value: declaration[0]) {
            return value
        }
        return nil
    }
}

extension CSS.LengthOrPercentage: CSSPropertyValue {
    typealias T = CSS.LengthOrPercentage

    init?(_ styleValue: CSS.StyleValue?) {
        guard let styleValue else {
            return nil
        }
        switch styleValue {
        case let .length(length):
            self = .length(length)
        case let .percentage(percentage):
            self = .percentage(percentage)
        default:
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        switch self {
        case let .length(length):
            .length(length)
        case let .percentage(number):
            .percentage(number)
        }
    }
}

extension CSS.LengthOrPercentageOrAuto: CSSPropertyValue {
    typealias T = CSS.LengthOrPercentageOrAuto

    init?(_ styleValue: CSS.StyleValue?) {
        guard let styleValue else {
            return nil
        }
        switch styleValue {
        case let .length(length):
            self = .length(length)
        case let .percentage(number):
            self = .percentage(number)
        case .auto:
            self = .auto
        default:
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        switch self {
        case let .length(length):
            .length(length)
        case let .percentage(number):
            .percentage(number)
        case .auto:
            .auto
        }
    }
}
