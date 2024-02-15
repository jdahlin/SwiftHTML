extension Layout {
    struct PixelBox {
        var top = CSS.Pixels(0)
        var right = CSS.Pixels(0)
        var bottom = CSS.Pixels(0)
        var left = CSS.Pixels(0)
    }

    struct BoxModelMetrics {
        var margin: PixelBox = .init()
        var border: PixelBox = .init()
        var padding: PixelBox = .init()
        var inset: PixelBox = .init()
    }

    class NodeWithStyleAndBoxModelMetrics: NodeWithStyle {
        var boxModel: BoxModelMetrics = .init()
    }
}
