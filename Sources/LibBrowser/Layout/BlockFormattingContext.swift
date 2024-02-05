extension Layout {
    enum Mode {
        // Normal layout. No min-content or max-content constraints applied.
        case normal
        // Intrinsic size determination.
        // Boxes honor min-content and max-content constraints (set via LayoutState::UsedValues::{width,height}_constraint)
        // by considering their containing block to be 0-sized or infinitely large in the relevant axis.
        // https://drafts.csswg.org/css-sizing-3/#intrinsic-sizing
        case intrinsicSizing
    }

    class FormattingContext {
        var state: Layout.State
        var contextBox: Layout.Box
        var parent: FormattingContext?
        init(state: Layout.State, contextBox: Layout.Box, parent: FormattingContext? = nil) {
            self.state = state
            self.contextBox = contextBox
            self.parent = parent
        }
    }

    enum AvailableSize: Equatable {
        case definite(CSS.Pixels)
        case indefinite(CSS.Pixels)
        case minContent(CSS.Pixels)
        case maxContent(CSS.Pixels)
    }

    struct AvailableSpace: Equatable {
        var width: AvailableSize
        var height: AvailableSize
    }

    class BlockFormattingContext: FormattingContext {
        func run(box _: Layout.Box, mode _: Mode, availableSpace _: AvailableSpace) {
            DIE("not implemented")

            // if root().children_are_inline():
            //     layout_inline_children(root(), layout_mode, available_space)
            // else
            //     layout_block_level_children(root(), layout_mode, available_space)
        }
    }
}
