extension Layout {
    class FormattingContext {
        enum ContextType {
            case block
            case inline
            case flex
            case grid
            case table
        }

        var state: Layout.State
        var contextBox: Layout.Box
        var parent: FormattingContext?
        init(state: Layout.State, contextBox: Layout.Box, parent: FormattingContext? = nil) {
            self.state = state
            self.contextBox = contextBox
            self.parent = parent
        }

        func run(box _: Layout.Box, mode _: Mode, availableSpace _: AvailableSpace) {
            DIE("Not implemented")
        }

        func containingBlockWidthFor(node: Layout.NodeWithStyleAndBoxModelMetrics) -> CSS.Pixels {
            // FIXME: Immutable get
            let containingBlockState = state.getMutable(node: node.containingBlock()!)
            let nodeState = state.getMutable(node: node)
            return switch nodeState.widthContraint {
            case .none:
                containingBlockState.contentWidth
            case .minContent:
                CSS.Pixels(0)
            case .maxContent:
                CSS.Pixels(Int.max)
            }
        }

        func containingBlockHeightFor(node: Layout.NodeWithStyleAndBoxModelMetrics) -> CSS.Pixels {
            // FIXME: Immutable get
            let containingBlockState = state.getMutable(node: node.containingBlock()!)
            let nodeState = state.getMutable(node: node)
            return switch nodeState.heightContraint {
            case .none:
                containingBlockState.contentHeight
            case .minContent:
                CSS.Pixels(0)
            case .maxContent:
                CSS.Pixels(Int.max)
            }
        }

        // https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Block_formatting_context
        static func createsBlockFormattingContext(_ box: Box) -> Bool {
            // NOTE: Replaced elements never create a BFC.
            // if (box.is_replaced_box())
            //     return false;

            // display: table
            // if (box.display().is_table_inside()) {
            //     return false;
            // }

            // display: flex
            if box.display.isFlexInside() {
                return false
            }

            // display: grid
            // if (box.display().is_grid_inside()) {
            //     return false;
            // }

            // NOTE: This function uses MDN as a reference, not because it's authoritative,
            //       but because they've gathered all the conditions in one convenient location.

            // The root element of the document (<html>).
            if box.isRootElement() {
                return true
            }

            // Floats (elements where float isn't none).
            // if (box.is_floating())
            //     return true;

            // Absolutely positioned elements (elements where position is absolute or fixed).
            // if (box.is_absolutely_positioned())
            //     return true;

            // Inline-blocks (elements with display: inline-block).
            if box.display.isInlineBlock() {
                return true
            }

            // Table cells (elements with display: table-cell, which is the default for HTML table cells).
            // if (box.display().is_table_cell())
            //     return true;

            // Table captions (elements with display: table-caption, which is the default for HTML table captions).
            // if (box.display().is_table_caption())
            //     return true;

            // FIXME: Anonymous table cells implicitly created by the elements with display: table, table-row, table-row-group, table-header-group, table-footer-group
            //        (which is the default for HTML tables, table rows, table bodies, table headers, and table footers, respectively), or inline-table.

            // Block elements where overflow has a value other than visible and clip.
            // CSS::Overflow overflow_x = box.computed_values().overflow_x();
            // if ((overflow_x != CSS::Overflow::Visible) && (overflow_x != CSS::Overflow::Clip))
            //     return true;
            // CSS::Overflow overflow_y = box.computed_values().overflow_y();
            // if ((overflow_y != CSS::Overflow::Visible) && (overflow_y != CSS::Overflow::Clip))
            //     return true;

            // display: flow-root.
            if box.display.isFlowRootInside() {
                return true
            }

            // FIXME: Elements with contain: layout, content, or paint.

            if let parent = box.parent {
                let parentDisplay = parent.display

                // Flex items (direct children of the element with display: flex or inline-flex) if they are neither flex nor grid nor table containers themselves.
                if parentDisplay.isFlexInside() {
                    return true
                }
                // Grid items (direct children of the element with display: grid or inline-grid) if they are neither flex nor grid nor table containers themselves.
                if parentDisplay.isGridInside() {
                    return true
                }
            }

            // FIXME: Multicol containers (elements where column-count or
            // column-width isn't auto, including elements with column-count:
            // 1).

            // FIXME: column-span: all should always create a new formatting
            // context, even when the column-span: all element isn't contained
            // by a multicol container (Spec change, Chrome bug).

            return false
        }

        func computeInset(box: NodeWithStyleAndBoxModelMetrics) {
            // FIXME: assert position != relative

            func resolveTwoOpposingInsets(
                computedFirst: CSS.LengthOrPercentageOrAuto,
                computedSecond: CSS.LengthOrPercentageOrAuto,
                usedStart: inout CSS.Pixels,
                usedEnd: inout CSS.Pixels,
                referenceForPercentage: CSS.Pixels
            ) {
                let resolvedFirst = computedFirst.toPx(layoutNode: box, referenceValue: referenceForPercentage)
                let resolvedSecond = computedSecond.toPx(layoutNode: box, referenceValue: referenceForPercentage)
                if case .auto = computedFirst, case .auto = computedSecond {
                    usedStart = CSS.Pixels(0)
                    usedEnd = CSS.Pixels(0)
                } else if case .auto = computedFirst {
                    usedEnd = resolvedSecond
                    usedStart = -usedEnd
                } else {
                    usedStart = resolvedFirst
                    usedEnd = -usedStart
                }
            }
            let boxState = state.getMutable(node: box)
            let computedValues = box.computedValues
            resolveTwoOpposingInsets(computedFirst: computedValues.inset.left,
                                     computedSecond: computedValues.inset.right,
                                     usedStart: &boxState.insetLeft,
                                     usedEnd: &boxState.insetRight,
                                     referenceForPercentage: containingBlockWidthFor(node: box))
            resolveTwoOpposingInsets(computedFirst: computedValues.inset.top,
                                     computedSecond: computedValues.inset.bottom,
                                     usedStart: &boxState.insetTop,
                                     usedEnd: &boxState.insetBottom,
                                     referenceForPercentage: containingBlockHeightFor(node: box))
        }

        static func formattingContextTypeCreatedByBox(_ box: Box) -> FormattingContext.ContextType? {
            // if !box.canHaveChildren {
            //     return nil
            // }

            let display = box.display
            if display.isFlexInside() {
                return .flex
            }
            if display.isTableInside() {
                return .table
            }
            if display.isGridInside() {
                return .grid
            }
            if createsBlockFormattingContext(box) {
                return .block
            }
            return nil
        }

        func createIndependentFormattingContextIfNeeded(_ state: Layout.State, _ childBox: Layout.Box) -> BlockFormattingContext? {
            guard let contextType = FormattingContext.formattingContextTypeCreatedByBox(childBox) else {
                return nil
            }

            return switch contextType {
            case .block:
                BlockFormattingContext(state: state, contextBox: childBox, parent: self)
            default:
                DIE("\(contextType)")
            }
        }

        func shouldTreatWidthAsAuto(box: Box, availableSpace: AvailableSpace) -> Bool {
            if case .auto = box.computedValues.width {
                return true
            }
            if box.computedValues.width.containsPercentage() {
                if case .maxContent = availableSpace.width {
                    return true
                }
                if case .indefinite = availableSpace.width {
                    return true
                }
            }
            return false
        }

        func shouldTreatMaxWidthAsNone(box: Box, availableWidth: AvailableSize) -> Bool {
            let maxWidth = box.computedValues.maxWidth
            if case .none = maxWidth {
                return true
            }
            // FIXME: absolute
            if maxWidth.containsPercentage() {
                if case .maxContent = availableWidth {
                    return true
                }
                if case .minContent = availableWidth {
                    return false
                }
                let node = box.nonAnonymousContainingBlock() as! Layout.NodeWithStyle
                if state.getMutable(node: node).hasDefiniteWidth {
                    return true
                }
            }
            if box.childrenAreInline {
                switch (maxWidth, availableWidth) {
                case (.fitContent, _) where availableWidth.isIntrinsicSizingConstraint():
                    return true
                case (.maxContent, .maxContent):
                    return true
                case (.minContent, .minContent):
                    return true
                default:
                    break
                }
            }

            return false
        }
    }
}
