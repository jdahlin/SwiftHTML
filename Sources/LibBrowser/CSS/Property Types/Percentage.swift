extension CSS {
    struct Percentage: Equatable, CustomStringConvertible {
        let value: Double

        init(_ value: Double) {
            self.value = value
        }

        func asFraction() -> Double {
            value / 100
        }

        var description: String {
            "\(value)%"
        }
    }
}
