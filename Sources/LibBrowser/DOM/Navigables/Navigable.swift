class Navigable {
    var viewportScrollOffset: CSS.PixelRect = .init(
        x: CSS.Pixels(0),
        y: CSS.Pixels(0),
        width: CSS.Pixels(800),
        height: CSS.Pixels(600)
    )

    func setViewportRect(_ rect: CSS.PixelRect) {
        viewportScrollOffset = rect
    }

    func viewportRect() -> CSS.PixelRect {
        viewportScrollOffset
    }
}
