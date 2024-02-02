extension CSS {
    struct Rect<T> {
        var x: T
        var y: T
        var width: T
        var height: T
    }

    typealias PixelRect = Rect<CSS.Pixels>
}
