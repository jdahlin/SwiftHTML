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

        func containingBlockWithFor(node: Layout.NodeWithStyleAndBoxModelMetrics) -> CSS.Pixels {
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

        // https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Block_formatting_context
        func createsBlockFormattingContext(_ box: Box) -> Bool {
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

        enum ContextType {
            case block
            case inline
            case flex
            case grid
            case table
        }

        func formattingContextTypeCreatedByBox(_ box: Box) -> FormattingContext.ContextType? {
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
            guard let contextType = formattingContextTypeCreatedByBox(childBox) else {
                return nil
            }

            return switch contextType {
            case .block:
                BlockFormattingContext(state: state, contextBox: childBox, parent: self)
            default:
                DIE("\(contextType)")
            }
        }
    }

    enum AvailableSize: Equatable {
        case definite(CSS.Pixels)
        case indefinite(CSS.Pixels)
        case minContent(CSS.Pixels)
        case maxContent(CSS.Pixels)

        func toPxOrZero() -> CSS.Pixels {
            guard case let .definite(value) = self else {
                return CSS.Pixels(0)
            }
            return value
        }
    }

    struct AvailableSpace: Equatable {
        var width: AvailableSize
        var height: AvailableSize
    }

    struct BlockMarginState {
        var currentCollapsibleMargins: [CSS.Pixels]
        var blockContainerYPositionUpdateCallback: ((CSS.Pixels) -> Void)?

        mutating func addMargin(_ margin: CSS.Pixels) {
            currentCollapsibleMargins.append(margin)
        }

        func updateBlockWaitingForFinalYPosition() {
            if blockContainerYPositionUpdateCallback != nil {
                let margin = currentCollapsedMargin()
                blockContainerYPositionUpdateCallback!(margin)
            }
        }

        func currentCollapsedMargin() -> CSS.Pixels {
            var smallestMargin = CSS.Pixels(0)
            var largestMargin = CSS.Pixels(0)
            var negativeMarginCount = 0

            for margin in currentCollapsibleMargins {
                if margin < CSS.Pixels(0) {
                    negativeMarginCount += 1
                }
                largestMargin = max(largestMargin, margin)
                smallestMargin = min(smallestMargin, margin)
            }

            var collapsedMargin = CSS.Pixels(0)

            if negativeMarginCount == currentCollapsibleMargins.count {
                // When all margins are negative, the size of the collapsed margin is the smallest (most negative) margin.
                collapsedMargin = smallestMargin
            } else if negativeMarginCount > 0 {
                // When negative margins are involved, the size of the collapsed margin is the sum of the largest positive margin and the smallest (most negative) negative margin.
                collapsedMargin = largestMargin + smallestMargin
            } else {
                // Otherwise, collapse all the adjacent margins by using only the largest one.
                collapsedMargin = largestMargin
            }

            return collapsedMargin
        }

        func hasBlockContainerWaitingForFinalYPosition() -> Bool {
            blockContainerYPositionUpdateCallback != nil
        }

        mutating func reset() {
            currentCollapsibleMargins = []
            blockContainerYPositionUpdateCallback = nil
        }
    }

    class BlockFormattingContext: FormattingContext {
        var marginState: BlockMarginState = .init(currentCollapsibleMargins: [])
        var yOffsetOfCurrentBlockContainer: CSS.Pixels?

        // https://www.w3.org/TR/css-display/#block-formatting-context-root
        func root() -> BlockContainer {
            contextBox as! BlockContainer
        }

        func run(box _: Layout.Box, mode: Mode, availableSpace: AvailableSpace) {
            let blockContainer = root()
            if blockContainer.childrenAreInline {
                layoutInlineChildren(blockContainer: blockContainer, mode, availableSpace)
            } else {
                layoutBlockLevelChildren(blockContainer: blockContainer, mode, availableSpace)
            }
        }

        func layoutInlineChildren(blockContainer _: BlockContainer, _: Mode, _: AvailableSpace) {
            DIE()
        }

        func layoutBlockLevelChildren(blockContainer: BlockContainer, _ mode: Mode, _ availableSpace: AvailableSpace) {
            assert(mode == .normal)

            var bottomOfLowestMarginBox = 0
            blockContainer.children
                .filter { $0 is Box }
                .forEach { box in
                    layoutBlockLevelBox(
                        box: box as! Layout.Box,
                        blockContainer: blockContainer,
                        mode: mode,
                        bottomOfLowestMarginBox: &bottomOfLowestMarginBox,
                        availableSpace: availableSpace
                    )
                }
            // marginState
        }

        func layoutBlockLevelBox(box: Layout.Box,
                                 blockContainer _: BlockContainer,
                                 mode: Mode,
                                 bottomOfLowestMarginBox _: inout Int,
                                 availableSpace: AvailableSpace)
        {
            var boxState = state.getMutable(node: box)

            // FIXME: absolute
            // FIXME: list-item-marker-box
            resolveVerticalBoxModelMetrics(box: box)
            // FIXME: float
            marginState.addMargin(boxState.marginTop)

            let y = yOffsetOfCurrentBlockContainer ?? CSS.Pixels(0)

            // FIXME: quirks
            var boxIsHtmlElementInQuirksMode = false
            if boxState.hasDefiniteHeight || boxIsHtmlElementInQuirksMode {
                computeHeight(box: box, availableSpace: availableSpace)
            }

            let independentFormattingContext = createIndependentFormattingContextIfNeeded(state, box)
            marginState.updateBlockWaitingForFinalYPosition()
            var marginTop = marginState.currentCollapsedMargin()
            if marginState.hasBlockContainerWaitingForFinalYPosition() {
                marginTop = CSS.Pixels(0)
            }

            if independentFormattingContext != nil {
                marginState.reset()
            }

            placeBlockLevelElementInNormalFlowVertically(childBox: box, y: y + marginTop)
            computeWidth(box: box, availableSpace: availableSpace, mode: mode)
            DIE()
        }

        func placeBlockLevelElementInNormalFlowVertically(childBox: Box, y: CSS.Pixels) {
            let boxState = state.getMutable(node: childBox)
            var newY = y + boxState.borderBoxTop
            boxState.setContentOffset(CSS.PixelPoint(x: boxState.offset.x, y: newY))
        }

        func resolveVerticalBoxModelMetrics(box: Layout.Box) {
            let boxState = state.getMutable(node: box)
            let computedValues = box.computedValues
            let widthOfContainingBlock = containingBlockWithFor(node: box)

            boxState.marginTop = computedValues.margin.top.toPx(node: box, referenceValue: widthOfContainingBlock)
            boxState.marginBottom = computedValues.margin.bottom.toPx(node: box, referenceValue: widthOfContainingBlock)
            boxState.borderTop = computedValues.borderTop.width
            boxState.borderBottom = computedValues.borderBottom.width
            boxState.paddingTop = computedValues.padding.top.toPx(node: box, referenceValue: widthOfContainingBlock)
            boxState.paddingBottom = computedValues.padding.bottom.toPx(node: box, referenceValue: widthOfContainingBlock)
        }

        func computeHeight(box: Layout.Box, availableSpace: AvailableSpace) {
            let computedValues = box.computedValues
            var height = CSS.Pixels(0)
            // FIXME: Replaced Element
            if shouldTreatHeightAsAuto(box: box, availableSpace: availableSpace) {
                let newAvailableSpace = state.getMutable(node: box).availableInnerSpaceOrConstraintsFrom(availableSpace)
                computeAutoHeightForBlockLevelElement(box: box, availableSpace: newAvailableSpace)
            }

            switch computedValues.minHeight {
            case .auto:
                break
            case let minHeight:
                DIE("min-height: \(minHeight)")
            }

            state.getMutable(node: box).contentHeight = height
        }

        func computeWidth(box: Layout.Box, availableSpace: AvailableSpace, mode _: Mode) {
            // FIXME: absolutely
            let remainingAvailableSpace = availableSpace
            // FIXME: float
            // FIXME: replaced
            let computedValues = box.computedValues
            let widthOfContainingBlock = remainingAvailableSpace.width.toPxOrZero()
            let zeroValue = CSS.Pixels(0)
            var marginLeft: CSS.LengthOrPercentageOrAuto = .auto
            var marginRight: CSS.LengthOrPercentageOrAuto = .auto
            let paddingLeft = computedValues.padding.left.toPx(node: box, referenceValue: widthOfContainingBlock)
            let paddingRight = computedValues.padding.right.toPx(node: box, referenceValue: widthOfContainingBlock)

            let boxState = state.getMutable(node: box)
            boxState.borderLeft = computedValues.borderLeft.width
            boxState.borderRight = computedValues.borderRight.width
            boxState.paddingLeft = paddingLeft
            boxState.paddingRight = paddingRight

            guard case .none = boxState.widthContraint else {
                FIXME("\(boxState.widthContraint)")
                return
            }

            func tryComputeWidth(aWidth _: CSS.Length) {}

            let inputWidth: CSS.LengthOrPercentageOrAuto = {
                if shouldTreatHeightAsAuto(box: box, availableSpace: remainingAvailableSpace) {
                    return .auto
                }
                return .length(.absolute(.px(calculateInnerWidth(box: box, availableSpace: remainingAvailableSpace, width: computedValues.width))))
            }()
        }

        func shouldTreatHeightAsAuto(box: Layout.Box, availableSpace: AvailableSpace) -> Bool {
            let computedHeight = box.computedValues.height
            switch computedHeight {
            case .auto:
                return true
            case .minContent, .maxContent, .fitContent:
                return true
            case .percentage:
                switch availableSpace.height {
                case .indefinite, .maxContent:
                    return true
                default:
                    break
                }
            default: /* length, none */
                break
            }
            return false
        }

        func computeAutoHeightForBlockLevelElement(box: Layout.Box, availableSpace _: AvailableSpace) -> CSS.Pixels {
            if createsBlockFormattingContext(box) {
                return computeAutoHeightForBlockFormattingContextRoot(box)
            }
            DIE()
        }

        // https://www.w3.org/TR/CSS22/visudet.html#root-height
        func computeAutoHeightForBlockFormattingContextRoot(_ root: Box) -> CSS.Pixels {
            var top: CSS.Pixels?
            let bottom: CSS.Pixels?

            if root.childrenAreInline {
                let lineBoxes = state.getMutable(node: root).lineBoxes
                top = CSS.Pixels(0)
                if !lineBoxes.isEmpty {
                    bottom = lineBoxes.last!.bottom
                }
            } else {
                DIE("!childrenAreInline")
            }
            DIE("continue")
        }

        func calculateInnerWidth(box _: Layout.Box, availableSpace _: AvailableSpace, width _: CSS.Size) -> Double {
            // return width.toPx(node: box, referenceValue: availableSpace.width.toPxOrZero()).toDouble()
            DIE()
        }
    }
}
