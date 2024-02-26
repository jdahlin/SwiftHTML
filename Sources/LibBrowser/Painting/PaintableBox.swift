extension Painting {
    class PaintableBox: Paintable {
        var offset: CSS.PixelPoint = .init(x: CSS.Pixels(0), y: CSS.Pixels(0))
        var contentSize: CSS.PixelSize = .init(width: CSS.Pixels(0), height: CSS.Pixels(0))
        var absoluteRect: CSS.PixelRect?

        var contentWidth: Int { contentSize.width.toInt() }
        var contentHeight: Int { contentSize.height.toInt() }

        var absoluteX: Int {
            getAbsoluteRect().x.toInt()
        }

        var absoluteY: Int {
            getAbsoluteRect().y.toInt()
        }

        func setOffset(_ offset: CSS.PixelPoint) {
            self.offset = offset
        }

        func setContentSize(width: CSS.Pixels, height: CSS.Pixels) {
            contentSize = CSS.PixelSize(width: width, height: height)
        }

        func getAbsoluteRect() -> CSS.PixelRect {
            if let absoluteRect {
                return absoluteRect
            }
            absoluteRect = computeAbsoluteRect()
            return absoluteRect!
        }

        func computeAbsoluteRect() -> CSS.PixelRect {
            var rect = CSS.PixelRect(
                x: offset.x,
                y: offset.y,
                width: contentSize.width,
                height: contentSize.height
            )
            var block = containingBlock()
            while block != nil, let paintableBox = block?.paintableBox() {
                rect.translateBy(paintableBox.offset)
                block = block?.paintable?.containingBlock()
            }
            return rect
        }
    }

    class PaintableWithLines: PaintableBox {}
}
