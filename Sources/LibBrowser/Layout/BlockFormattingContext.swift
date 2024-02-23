extension Layout {
    enum AutoOr<T>: Equatable {
        case auto
        case value(T)

        func toPx(layoutNode: Layout.Node) -> CSS.Pixels {
            switch self {
            case .auto:
                return CSS.Pixels(0)
            case let .value(value):
                if T.self == CSS.Length.self {
                    return (value as! CSS.Length).toPx(layoutNode: layoutNode)
                }
                DIE()
            }
        }

        static func == (lhs: AutoOr<T>, rhs: AutoOr<T>) -> Bool {
            switch (lhs, rhs) {
            case (.auto, .auto):
                return true
            case let (.value(lhsValue), .value(rhsValue)):
                if T.self == CSS.Length.self {
                    return (lhsValue as! CSS.Length) == (rhsValue as! CSS.Length)
                }
                DIE()
            default:
                return false
            }
        }

        func isAuto() -> Bool {
            switch self {
            case .auto: true
            case .value: false
            }
        }
    }

    enum Mode {
        // Normal layout. No min-content or max-content constraints applied.
        case normal
        // Intrinsic size determination.
        // Boxes honor min-content and max-content constraints (set via LayoutState::UsedValues::{width,height}_constraint)
        // by considering their containing block to be 0-sized or infinitely large in the relevant axis.
        // https://drafts.csswg.org/css-sizing-3/#intrinsic-sizing
        case intrinsicSizing
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

        func isIntrinsicSizingConstraint() -> Bool {
            switch self {
            case .minContent, .maxContent:
                true
            default:
                false
            }
        }
    }

    struct AvailableSpace: Equatable {
        var width: AvailableSize
        var height: AvailableSize
    }

    struct BlockMarginState {
        var currentCollapsibleMargins: [CSS.Pixels]
        var blockContainerYPositionUpdateCallback: ((CSS.Pixels) -> Void)?
        var boxLastInFlowChildMarginBottomCollapsed = false

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

        override func run(box _: Layout.Box, mode: Mode, availableSpace: AvailableSpace) {
            let blockContainer = root()
            if blockContainer.childrenAreInline {
                layoutInlineChildren(blockContainer: blockContainer, mode: mode, availableSpace: availableSpace)
            } else {
                layoutBlockLevelChildren(blockContainer: blockContainer, mode: mode, availableSpace: availableSpace)
            }
        }

        func layoutInlineChildren(blockContainer: BlockContainer, mode: Mode, availableSpace: AvailableSpace) {
            assert(blockContainer.childrenAreInline)
            let blockContainerState = state.getMutable(node: blockContainer)
            let inlineContext = InlineFormattingContext(state: state, contextBox: blockContainer, parent: self)

            inlineContext.run(box: blockContainer, mode: mode, availableSpace: availableSpace)

            if !blockContainerState.hasDefiniteWidth {
                var usedWidthPx = inlineContext.automaticContentWidth
                let containingBlockWidth = state.getMutable(node: blockContainer).contentWidth
                let availableWidth = AvailableSize.definite(containingBlockWidth)
                if !shouldTreatMaxWidthAsNone(box: blockContainer, availableWidth: availableSpace.width) {
                    let maxWidthPx = calculateInnerWidth(
                        box: blockContainer,
                        availableWidth: availableWidth,
                        width: blockContainer.computedValues.maxWidth
                    )
                    if usedWidthPx > maxWidthPx {
                        usedWidthPx = maxWidthPx
                    }
                }

                let shouldTreatMinWidthAsAuto = switch (blockContainer.computedValues.minWidth, availableSpace.width) {
                case (.auto, _):
                    true
                case let (.fitContent, availableWidth) where availableWidth.isIntrinsicSizingConstraint():
                    true
                case (.maxContent, .maxContent):
                    true
                case (.minContent, .minContent):
                    true
                default: false
                }

                if shouldTreatMinWidthAsAuto {
                    let minWidthPx = calculateInnerWidth(
                        box: blockContainer,
                        availableWidth: availableWidth,
                        width: blockContainer.computedValues.minWidth
                    )
                    if usedWidthPx < minWidthPx {
                        usedWidthPx = minWidthPx
                    }
                }

                blockContainerState.contentWidth = usedWidthPx
            }

            if !blockContainerState.hasDefiniteHeight {
                blockContainerState.contentHeight = inlineContext.automaticContentHeight
            }
        }

        func layoutBlockLevelChildren(blockContainer: BlockContainer, mode: Mode, availableSpace: AvailableSpace) {
            assert(mode == .normal)

            var bottomOfLowestMarginBox = CSS.Pixels(0)
            blockContainer.children
                .filter { $0 is Box }
                .forEach { box in
                    print("layoutBlockLevelBox: \(availableSpace)")
                    layoutBlockLevelBox(
                        box: box as! Layout.Box,
                        blockContainer: blockContainer,
                        mode: mode,
                        bottomOfLowestMarginBox: &bottomOfLowestMarginBox,
                        availableSpace: availableSpace
                    )
                }
            if mode == .intrinsicSizing {
                FIXME("intrinsic sizing")
            }
        }

        func layoutBlockLevelBox(box: Layout.Box,
                                 blockContainer _: BlockContainer,
                                 mode: Mode,
                                 bottomOfLowestMarginBox: inout CSS.Pixels,
                                 availableSpace: AvailableSpace)
        {
            let boxState = state.getMutable(node: box)

            // FIXME: absolute
            // FIXME: list-item-marker-box
            resolveVerticalBoxModelMetrics(box: box)
            // FIXME: float
            marginState.addMargin(boxState.marginTop)

            let y = yOffsetOfCurrentBlockContainer ?? CSS.Pixels(0)

            // FIXME: quirks
            let boxIsHtmlElementInQuirksMode = false
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
            placeBlockLevelElementInNormalFlowHorizontally(childBox: box, availableSpace: availableSpace)

            // FIXME: replaced/flex

            if independentFormattingContext != nil {
                independentFormattingContext!.run(box: box, mode: mode, availableSpace: availableSpace)
            } else {
                if box.childrenAreInline {
                    let innerSpace = boxState.availableInnerSpaceOrConstraintsFrom(availableSpace)
                    layoutInlineChildren(
                        blockContainer: box as! BlockContainer,
                        mode: mode,
                        availableSpace: innerSpace
                    )
                } else {
                    if boxState.borderTop > CSS.Pixels(0) || boxState.paddingTop > CSS.Pixels(0) {
                        marginState.reset()
                    } else if marginState.hasBlockContainerWaitingForFinalYPosition() {
                        FIXME("margin top")
                    }
                    layoutBlockLevelChildren(
                        blockContainer: box as! BlockContainer,
                        mode: mode,
                        availableSpace: boxState.availableInnerSpaceOrConstraintsFrom(availableSpace)
                    )
                }
            }

            // FIXME: table

            if independentFormattingContext != nil /* || marginsCollapseThrough(box, state) */ {
                yOffsetOfCurrentBlockContainer = boxState.offset.y + boxState.contentHeight
            }
            marginState.boxLastInFlowChildMarginBottomCollapsed = false
            marginState.addMargin(boxState.marginBottom)
            marginState.updateBlockWaitingForFinalYPosition()
            computeInset(box: box)

            // FIXME: list item box

            bottomOfLowestMarginBox = max(bottomOfLowestMarginBox, boxState.offset.y + boxState.contentHeight)
            if independentFormattingContext != nil {
                FIXME("parent_context_did_dimension_child_root_box")
            }
        }

        func placeBlockLevelElementInNormalFlowVertically(childBox: Box, y: CSS.Pixels) {
            let boxState = state.getMutable(node: childBox)
            let newY = y + boxState.borderBoxTop
            boxState.setContentOffset(CSS.PixelPoint(x: boxState.offset.x, y: newY))
        }

        func placeBlockLevelElementInNormalFlowHorizontally(childBox: Box, availableSpace: AvailableSpace) {
            let boxState = state.getMutable(node: childBox)
            var x = availableSpace.width.toPxOrZero()
            // FIXME: float
            // FIME: text-align
            x += boxState.marginBoxLeft
            boxState.setContentOffset(CSS.PixelPoint(x: x, y: boxState.offset.y))
        }

        func resolveVerticalBoxModelMetrics(box: Layout.Box) {
            let boxState = state.getMutable(node: box)
            let computedValues = box.computedValues
            let widthOfContainingBlock = containingBlockWidthFor(node: box)

            boxState.marginTop = computedValues.margin.top.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)
            boxState.marginBottom = computedValues.margin.bottom.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)
            boxState.borderTop = computedValues.borderTop.width
            boxState.borderBottom = computedValues.borderBottom.width
            boxState.paddingTop = computedValues.padding.top.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)
            boxState.paddingBottom = computedValues.padding.bottom.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)
        }

        func computeHeight(box: Layout.Box, availableSpace: AvailableSpace) {
            let computedValues = box.computedValues
            var height = CSS.Pixels(0)
            // FIXME: Replaced Element
            if shouldTreatHeightAsAuto(box: box, availableSpace: availableSpace) {
                let newAvailableSpace = state.getMutable(node: box).availableInnerSpaceOrConstraintsFrom(availableSpace)
                height = computeAutoHeightForBlockLevelElement(box: box, availableSpace: newAvailableSpace)
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
            let zeroValue = CSS.Length(0.0)
            let marginLeft: CSS.LengthOrPercentageOrAuto = .auto
            let marginRight: CSS.LengthOrPercentageOrAuto = .auto
            let paddingLeft = computedValues.padding.left.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)
            let paddingRight = computedValues.padding.right.toPx(layoutNode: box, referenceValue: widthOfContainingBlock)

            let boxState = state.getMutable(node: box)
            boxState.borderLeft = computedValues.borderLeft.width
            boxState.borderRight = computedValues.borderRight.width
            boxState.paddingLeft = paddingLeft
            boxState.paddingRight = paddingRight

            guard case .none = boxState.widthContraint else {
                FIXME("\(boxState.widthContraint)")
                return
            }

            func tryComputeWidth(inputWidth: AutoOr<CSS.Length>) -> AutoOr<CSS.Length> {
                var width = inputWidth
                var marginLeft = computedValues.margin.left.resolved(layoutNode: box, referenceValue: widthOfContainingBlock)
                var marginRight = computedValues.margin.right.resolved(layoutNode: box, referenceValue: widthOfContainingBlock)
                var totalPx = CSS.Pixels(0)
                totalPx += computedValues.borderLeft.width
                totalPx += marginLeft.toPx(layoutNode: box)
                totalPx += paddingLeft
                totalPx += width.toPx(layoutNode: box)
                totalPx += paddingRight
                totalPx += marginRight.toPx(layoutNode: box)
                totalPx += computedValues.borderRight.width

                if !box.isInline() {
                    // 10.3.3 Block-level, non-replaced elements in normal flow
                    // If 'width' is not 'auto' and 'border-left-width' + 'padding-left' + 'width' + 'padding-right' + 'border-right-width' (plus any of 'margin-left' or 'margin-right' that are not 'auto') is larger than the width of the containing block, then any 'auto' values for 'margin-left' or 'margin-right' are, for the following rules, treated as zero.
                    if width != .auto, totalPx > widthOfContainingBlock {
                        if case .auto = marginLeft {
                            marginLeft = .value(zeroValue)
                        }
                        if marginRight.isAuto() {
                            marginRight = .value(zeroValue)
                        }
                    }

                    // 10.3.3 cont'd.
                    var underflowPx = widthOfContainingBlock - totalPx
                    if availableSpace.width.isIntrinsicSizingConstraint() {
                        underflowPx = CSS.Pixels(0)
                    }

                    if width.isAuto() {
                        if case .auto = marginLeft {
                            marginLeft = .value(zeroValue)
                        }
                        if marginRight.isAuto() {
                            marginRight = .value(zeroValue)
                        }

                        if case .definite = availableSpace.width {
                            if underflowPx >= CSS.Pixels(0) {
                                width = .value(CSS.Length(underflowPx))
                            } else {
                                width = .value(zeroValue)
                                marginRight = .value(CSS.Length(marginRight.toPx(layoutNode: box) + underflowPx))
                            }
                        }
                    } else {
                        switch (marginLeft, marginRight) {
                        case (.auto, .auto):
                            let half: AutoOr<CSS.Length> = .value(CSS.Length(underflowPx / 2))
                            marginLeft = half
                            marginRight = half
                        case (.auto, _):
                            marginLeft = .value(CSS.Length(underflowPx))
                        case (_, .auto):
                            marginRight = .value(CSS.Length(underflowPx))
                        case (_, _):
                            marginRight = .value(CSS.Length(marginRight.toPx(layoutNode: box) + underflowPx))
                        }
                    }
                }
                return width
            }

            let inputWidth: AutoOr<CSS.Length> = {
                if shouldTreatHeightAsAuto(box: box, availableSpace: remainingAvailableSpace) {
                    return .auto
                }
                let innerWidth = self.calculateInnerWidth(
                    box: box,
                    availableWidth: remainingAvailableSpace.width,
                    width: computedValues.width
                )
                let value = innerWidth.toDouble()
                return .value(.absolute(.px(value)))
            }()

            // 1. The tentative used width is calculated (without 'min-width' and 'max-width')
            var usedWidth = tryComputeWidth(inputWidth: inputWidth)

            // 2. The tentative used width is greater than 'max-width', the rules above are applied again,
            //    but this time using the computed value of 'max-width' as the computed value for 'width'.
            if !shouldTreatMaxWidthAsNone(box: box, availableWidth: availableSpace.width) {
                let maxWidth = calculateInnerWidth(box: box, availableWidth: remainingAvailableSpace.width, width: computedValues.maxWidth)
                let usedWidthPx = if case .auto = usedWidth {
                    CSS.Pixels(0)
                } else {
                    usedWidth.toPx(layoutNode: box)
                }
                if usedWidthPx > maxWidth {
                    usedWidth = tryComputeWidth(inputWidth: .value(CSS.Length(maxWidth)))
                }
            }

            // 3. If the resulting width is smaller than 'min-width', the rules above are applied again,
            //    but this time using the value of 'min-width' as the computed value for 'width'.
            if computedValues.minWidth != .auto {
                let minWidth = calculateInnerWidth(box: box, availableWidth: remainingAvailableSpace.width, width: computedValues.minWidth)
                let usedWidthPx = if case .auto = usedWidth {
                    remainingAvailableSpace.width
                } else {
                    AvailableSize.definite(usedWidth.toPx(layoutNode: box))
                }
                if usedWidthPx.toPxOrZero() < minWidth {
                    usedWidth = tryComputeWidth(inputWidth: .value(CSS.Length(minWidth)))
                }
            }

            if true {
                boxState.setContentWidth(usedWidth.toPx(layoutNode: box))
            }
            boxState.marginLeft = marginLeft.toPx(layoutNode: box)
            boxState.marginRight = marginRight.toPx(layoutNode: box)
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
            if FormattingContext.createsBlockFormattingContext(box) {
                return computeAutoHeightForBlockFormattingContextRoot(box)
            }
            DIE()
        }

        // https://www.w3.org/TR/CSS22/visudet.html#root-height
        func computeAutoHeightForBlockFormattingContextRoot(_ root: Box) -> CSS.Pixels {
            let top: CSS.Pixels?
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

        func calculateInnerWidth(box: Layout.Box, availableWidth: AvailableSize, width: CSS.Size) -> CSS.Pixels {
            let widthOfContainingBlock = availableWidth.toPxOrZero()
            switch width {
            case .auto:
                FIXME("width cannot be auto here")
                return CSS.Pixels(0)
            case .fitContent:
                FIXME("fit-content not implemented")
                return CSS.Pixels(0)
            case .maxContent:
                FIXME("max-content not implemented")
                return CSS.Pixels(0)
            case .minContent:
                FIXME("min-content not implemented")
                return CSS.Pixels(0)
            default:
                break
            }
            let computedValues = box.computedValues
            if computedValues.boxSizing == CSS.BoxSizing.borderBox {
                FIXME("border box")
                return CSS.Pixels(0)
            }
            return width.toPx(node: box, referenceValue: widthOfContainingBlock)
        }
    }
}
