extension Layout {
    class BlockContainer: Box {
        override func createPaintable() -> Painting.Paintable? {
            Painting.PaintableWithLines(layoutNode: self)
        }
    }
}
