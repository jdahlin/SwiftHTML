extension CSS {
    struct Property<T>: CustomStringConvertible {
        var name: String?
        var value: PropertyValue<T>
        var important: Bool = false
        var caseSensitive: Bool = true

        init() {
            // https://drafts.csswg.org/css-cascade/#initial-values
            // Each property has an initial value, defined in the property’s
            // definition table. If the property is not an inherited property,
            // and the cascade does not result in a value, then the specified
            // value of the property is its initial value.
            value = .initial
        }

        init(name: String, value: PropertyValue<T>, important: Bool = false, caseSensitive: Bool = true) {
            self.name = name
            self.value = value
            self.important = important
            self.caseSensitive = caseSensitive
        }

        var description: String {
            if important {
                "Property(\(name!): \(value) !important)"
            } else {
                "Property(\(name!): \(value))"
            }
        }
    }

    enum PropertyValue<T>: CustomStringConvertible {
        case set(T)
        // https://www.w3.org/TR/css-values-4/#common-keywords
        // https://drafts.csswg.org/css-cascade/#defaulting-keywords
        case inherit
        case initial
        case revert
        case unset

        var description: String {
            switch self {
            case let .set(value):
                "\(value)"
            case .inherit:
                "inherit"
            case .initial:
                "initial"
            case .revert:
                "revert"
            case .unset:
                "unset"
            }
        }
    }
}
