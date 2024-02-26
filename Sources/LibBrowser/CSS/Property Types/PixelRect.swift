protocol Addable {
    static func + (lhs: Self, rhs: Self) -> Self
}

extension CSS {
    struct Rect<T: Addable> {
        var x: T
        var y: T
        var width: T
        var height: T
        mutating func translateBy(_ point: Point<T>) {
            x = x + point.x
            y = y + point.y
        }
    }

    typealias PixelRect = Rect<CSS.Pixels>
}
