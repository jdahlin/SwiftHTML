import Foundation

struct Point<T> {
    var x: T
    var y: T
}

extension CSS {
    typealias PixelPoint = Point<Pixels>

    struct Pixels {
        static let fractionalBits: Int = 6
        static let fixedPointDenominator = 1 << fractionalBits
        static let radixMask = fixedPointDenominator - 1
        static let maxIntegerValue = Int.max >> fractionalBits
        static let minIntegerValue = Int.min >> fractionalBits

        private(set) var value: Int = 0

        init() {}

        init<T: BinaryInteger>(_ value: T) {
            if value > T(Self.maxIntegerValue) {
                self.value = Int.max
            } else if value < T(Self.minIntegerValue) {
                self.value = Int.min
            } else {
                self.value = Int(value) << Self.fractionalBits
            }
        }

        init<T: BinaryFloatingPoint>(_ value: T) {
            if value.isNaN {
                self.value = 0
            } else {
                let rawValue = Int(value * T(Self.fixedPointDenominator))
                self.value = min(max(rawValue, Int.min), Int.max)
            }
        }

        static func fromRaw(_ value: Int) -> Self {
            var result = Self()
            result.setRawValue(value)
            return result
        }

        static func nearestValueFor<T: BinaryFloatingPoint>(_ value: T) -> Self {
            guard !value.isNaN else { return fromRaw(0) }

            let rawValue = Int((value * T(fixedPointDenominator)).rounded())
            // Note: The resolution of CSSPixels is 0.015625 (1/64), so care must be taken when converting
            // floats/doubles to CSSPixels as small values can underflow to zero,
            // or otherwise produce inaccurate results when scaled back up.
            if rawValue == 0, value != 0 {
                // In a real application, replace this print statement with appropriate logging.
                // Swift does not have a direct equivalent to dbgln_if, but you can use conditional logging.
                FIXME("CSS.Pixels: Conversion from float or double underflowed to zero")
            }
            return Self.fromRaw(rawValue)
        }

        func toFloat() -> Float {
            Float(value) / Float(Self.fixedPointDenominator)
        }

        func toDouble() -> Double {
            Double(value) / Double(Self.fixedPointDenominator)
        }

        func toInt() -> Int {
            value >> Self.fractionalBits
        }

        mutating func setRawValue(_ value: Int) {
            self.value = value
        }

        static func * (lhs: Self, rhs: Self) -> Self {
            fromRaw(lhs.value &* rhs.value >> fractionalBits)
        }

        static func * (lhs: Self, rhs: Double) -> Double {
            Double(lhs.value) * rhs
        }

        static func * (lhs: Double, rhs: Self) -> Double {
            lhs * Double(rhs.value)
        }

        static func + (lhs: Self, rhs: Self) -> Self {
            fromRaw(lhs.value &+ rhs.value)
        }

        static func + (lhs: Self, rhs: Int) -> Self {
            fromRaw(lhs.value &+ (rhs << fractionalBits))
        }

        static func - (lhs: Self, rhs: Self) -> Self {
            fromRaw(lhs.value &- rhs.value)
        }

        static func / (lhs: Self, rhs: Int) -> Self {
            fromRaw(lhs.value / rhs)
        }

        func round() -> Self {
            Pixels.fromRaw((value + Self.fixedPointDenominator / 2) & ~Self.radixMask)
        }
    }
}

extension CSS.Pixels: Comparable {
    static func < (lhs: CSS.Pixels, rhs: CSS.Pixels) -> Bool {
        lhs.value < rhs.value
    }

    static func == (lhs: CSS.Pixels, rhs: CSS.Pixels) -> Bool {
        lhs.value == rhs.value
    }
}
