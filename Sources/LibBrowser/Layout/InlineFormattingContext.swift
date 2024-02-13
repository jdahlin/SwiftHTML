extension Layout {
    class InlineFormattingContext: FormattingContext {
        var availableSpace: AvailableSpace?
        var containingBlockState: UsedValues!
        var automaticContentWidth = CSS.Pixels(0)
        var automaticContentHeight = CSS.Pixels(0)

        override init(state: Layout.State, contextBox: Layout.Box, parent: FormattingContext? = nil) {
            super.init(state: state, contextBox: contextBox, parent: parent)
            containingBlockState = state.getMutable(node: contextBox)
        }

        func containingBlock() -> BlockContainer {
            contextBox as! BlockContainer
        }

        override func run(box _: Layout.Box, mode _: Mode, availableSpace: AvailableSpace) {
            assert(containingBlock().childrenAreInline)
            self.availableSpace = availableSpace

            var contentHeight = CSS.Pixels(0)
            for lineBox in containingBlockState.lineBoxes {
                let lineBoxHeight = lineBox.height
                contentHeight += lineBoxHeight
            }
        }
    }
}
