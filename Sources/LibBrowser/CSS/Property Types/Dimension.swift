// Dimension
extension CSS {
    struct Dimension: CustomStringConvertible {
        var number: CSS.Number
        var unit: CSS.Length

        var description: String {
            "\(number)\(unit)"
        }
    }

    #if false
        static func parseDimension(value: [CSS.ComponentValue]) -> StyleValue {
            switch value.count {
            case 1:
                switch value[0] {
                case let .token(.dimension(number: number)):
                    return .set(number.number)
                case .token(.ident("inherit")):
                    return .inherit
                case .token(.ident("unset")):
                    return .unset
                case .token(.ident("revert")):
                    return .revert
                default:
                    break
                }
            default:
                break
            }
            FIXME("dimension value: \(value) not implemented")
            return .initial
        }
    #endif
}
