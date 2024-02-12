extension Layout {
    class UsedValues {
        var node: Layout.NodeWithStyle?
        var contentWidth = CSS.Pixels(0)
        var contentHeight = CSS.Pixels(0)
        var hasDefiniteWidth = false
        var hasDefiniteHeight = false

        var marginTop = CSS.Pixels(0)
        var marginRight = CSS.Pixels(0)
        var marginBottom = CSS.Pixels(0)
        var marginLeft = CSS.Pixels(0)

        var borderTop = CSS.Pixels(0)
        var borderRight = CSS.Pixels(0)
        var borderBottom = CSS.Pixels(0)
        var borderLeft = CSS.Pixels(0)

        var paddingTop = CSS.Pixels(0)
        var paddingRight = CSS.Pixels(0)
        var paddingBottom = CSS.Pixels(0)
        var paddingLeft = CSS.Pixels(0)

        var insetTop = CSS.Pixels(0)
        var insetRight = CSS.Pixels(0)
        var insetBottom = CSS.Pixels(0)
        var insetLeft = CSS.Pixels(0)

        var lineBoxes: [LineBox] = []
        var containingBlockUsedValues: UsedValues?

        var widthContraint: SizeConstraint = .none
        var heightContraint: SizeConstraint = .none

        var borderBoxTop: CSS.Pixels { borderTopCollapsed + paddingBottom }

        var borderTopCollapsed: CSS.Pixels { useCollapsingBordersModel ? (borderTop / 2).round() : borderTop }

        var useCollapsingBordersModel: Bool { overrideBorderData != nil }

        var overrideBorderData: Any?

        var offset: CSS.PixelPoint = .init(x: CSS.Pixels(0), y: CSS.Pixels(0))

        func setNode(node: Layout.NodeWithStyle, containingBlockUsedValues: UsedValues?) {
            self.node = node
            self.containingBlockUsedValues = containingBlockUsedValues
            let computedValues = node.computedValues

            func adjustForBoxSizing(unadjustedPixels: CSS.Pixels, computedValues: CSS.ComputedValues, width: Bool) -> CSS.Pixels {
                // FIXME: Box-sizing
                let borderAndPadding = if width {
                    computedValues.borderLeft.width +
                        computedValues.padding.left.pixels() +
                        computedValues.borderRight.width +
                        computedValues.padding.right.pixels()
                } else {
                    computedValues.borderTop.width +
                        computedValues.padding.top.pixels() +
                        computedValues.borderBottom.width +
                        computedValues.padding.bottom.pixels()
                }

                return unadjustedPixels - borderAndPadding
            }
            func isDefiniteSize(size: CSS.Size, resolvedDefiniteSize: inout CSS.Pixels, width: Bool) -> Bool {
                var containingBlockHasDefiniteSize = containingBlockUsedValues?.hasDefiniteWidth ?? false
                if !width {
                    containingBlockHasDefiniteSize = containingBlockUsedValues?.hasDefiniteHeight ?? false
                }

                if case .auto = size {
                    if !width { return false }
                    // if node.isFloating { return false}
                    // if node.isAbsolutelyPositioned { return false}
                    if !node.display.isBlockOutside() { return false }
                    guard let nodeParent = node.parent else { return false }
                    // if node.parent.isFloating { return false }
                    if !nodeParent.display.isFlowRootInside(), nodeParent.display.isFlowInside() { return false }
                    if !containingBlockHasDefiniteSize { return false }
                    let _ = containingBlockUsedValues?.contentWidth
                    // resolvedDefiniteSize = availableWidth
                    //     - marginLeft
                    //     - marginRight
                    //     - paddingLeft
                    //     - paddingRight
                    //     - borderLeft
                    //     - borderRight
                    return true
                }
                // FIXME: Calculated

                if case let .length(length) = size {
                    let _ = width ? containingBlockUsedValues?.contentWidth : containingBlockUsedValues?.contentHeight
                    resolvedDefiniteSize = adjustForBoxSizing(unadjustedPixels: length.toPx(layoutNode: node), computedValues: computedValues, width: width)
                    return true
                }
                if case let .percentage(percentage) = size {
                    let containingBlockSize = width ? containingBlockUsedValues?.contentWidth : containingBlockUsedValues?.contentHeight
                    resolvedDefiniteSize = containingBlockSize! * CSS.Pixels(percentage.toDouble())
                    FIXME("percentage resolution")
                    return true
                }

                return false
            }

            var minWidth = CSS.Pixels(0)
            let hasDefiniteMinWidth = isDefiniteSize(size: computedValues.minWidth, resolvedDefiniteSize: &minWidth, width: true)
            var maxWidth = CSS.Pixels(0)
            let hasDefiniteMaxWidth = isDefiniteSize(size: computedValues.maxWidth, resolvedDefiniteSize: &maxWidth, width: true)

            var minHeight = CSS.Pixels(0)
            let hasDefiniteMinHeight = isDefiniteSize(size: computedValues.minHeight, resolvedDefiniteSize: &minHeight, width: false)
            var maxHeight = CSS.Pixels(0)
            let hasDefiniteMaxHeight = isDefiniteSize(size: computedValues.maxHeight, resolvedDefiniteSize: &maxHeight, width: false)

            hasDefiniteWidth = isDefiniteSize(size: computedValues.width, resolvedDefiniteSize: &contentWidth, width: true)
            hasDefiniteHeight = isDefiniteSize(size: computedValues.height, resolvedDefiniteSize: &contentHeight, width: false)

            if hasDefiniteWidth {
                if hasDefiniteMinWidth {
                    contentWidth = max(contentWidth, minWidth)
                }
                if hasDefiniteMaxWidth {
                    contentWidth = min(contentWidth, maxWidth)
                }
            }

            if hasDefiniteHeight {
                if hasDefiniteMinHeight {
                    contentHeight = max(contentHeight, minHeight)
                }
                if hasDefiniteMaxHeight {
                    contentHeight = min(contentHeight, maxHeight)
                }
            }
        }

        func availableWithInside() -> AvailableSize {
            switch widthContraint {
            case .minContent:
                .minContent(CSS.Pixels(0))
            case .maxContent:
                .maxContent(CSS.Pixels(Int.max))
            case .none where hasDefiniteWidth:
                .definite(contentWidth)
            default:
                .indefinite(CSS.Pixels(Int.max))
            }
        }

        func availableHeightInside() -> AvailableSize {
            switch heightContraint {
            case .minContent:
                .minContent(CSS.Pixels(0))
            case .maxContent:
                .maxContent(CSS.Pixels(Int.max))
            case .none where hasDefiniteHeight:
                .definite(contentHeight)
            default:
                .indefinite(CSS.Pixels(Int.max))
            }
        }

        func availableInnerSpaceOrConstraintsFrom(_ outerSpace: AvailableSpace) -> AvailableSpace {
            var innerWidth = availableWithInside()
            var innerHeight = availableHeightInside()
            if case .indefinite = innerWidth, case .definite = outerSpace.width {
                innerWidth = outerSpace.width
            }
            if case .indefinite = innerHeight, case .definite = outerSpace.height {
                innerHeight = outerSpace.height
            }
            return AvailableSpace(width: innerWidth, height: innerHeight)
        }

        func setContentOffset(_ offset: CSS.PixelPoint) {
            setContentX(offset.x)
            setContentY(offset.y)
        }

        func setContentX(_ x: CSS.Pixels) {
            offset.x = x
        }

        func setContentY(_ y: CSS.Pixels) {
            offset.y = y
        }
    }

    enum SizeConstraint {
        case none
        case minContent
        case maxContent
    }

    class State {
        var root: State?
        var parent: State?
        var usedValuesPerLayoutNode: [Layout.NodeWithStyle: UsedValues] = [:]

        init(parent: State? = nil) {
            root = findRoot()
            self.parent = parent
        }

        func findRoot() -> State {
            var current = self
            while let parent = current.parent {
                current = parent
            }
            return current
        }

        func getMutable(node: NodeWithStyle) -> UsedValues {
            if let usedValues = usedValuesPerLayoutNode[node] {
                return usedValues
            }

            var ancestor = parent
            while let currentAncestor = ancestor {
                if let usedValues = currentAncestor.usedValuesPerLayoutNode[node] {
                    let cowUsedValues = usedValues
                    usedValuesPerLayoutNode[node] = cowUsedValues
                    return cowUsedValues
                }
                ancestor = currentAncestor.parent
            }

            let containingBlockUsedValues: UsedValues? =
                if node is Layout.ViewPort,
                let containingBlock = node.containingBlock() as NodeWithStyle? {
                    usedValuesPerLayoutNode[containingBlock]
                } else {
                    nil
                }

            let newUsedValues = UsedValues()
            newUsedValues.setNode(node: node, containingBlockUsedValues: containingBlockUsedValues)
            usedValuesPerLayoutNode[node] = newUsedValues
            return newUsedValues
        }

        func commit() {
            DIE("not implemented")
        }
    }
}
