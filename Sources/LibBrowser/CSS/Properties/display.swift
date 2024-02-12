extension CSS {
    // 2.1. Outer Display Roles for Flow Layout: the block, inline, and run-in keywords
    // https://drafts.csswg.org/css-display/#outer-role
    enum OuterDisplayType: CustomStringConvertible, EnumStringInit {
        case block
        case inline
        case runIn
        case none
        case contents

        init?(value: String) {
            switch value {
            case "none":
                self = .none
            case "contents":
                self = .contents
            case "block":
                self = .block
            case "inline":
                self = .inline
            case "run-in":
                self = .runIn
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .none:
                "none"
            case .contents:
                "contents"
            case .block:
                "block"
            case .inline:
                "inline"
            case .runIn:
                "run-in"
            }
        }
    }

    // 2.2. Inner Display Layout Models: the flow, flow-root, table, flex, grid, and ruby keywords
    // https://drafts.csswg.org/css-display/#inner-model
    enum InnerDisplayType: CustomStringConvertible, EnumStringInit {
        case flow
        case flowRoot
        case table
        case flex
        case grid
        case ruby

        init?(value: String) {
            switch value {
            case "flow":
                self = .flow
            case "flow-root":
                self = .flowRoot
            case "table":
                self = .table
            case "flex":
                self = .flex
            case "grid":
                self = .grid
            case "ruby":
                self = .ruby
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .flow:
                "flow"
            case .flowRoot:
                "flow-root"
            case .table:
                "table"
            case .flex:
                "flex"
            case .grid:
                "grid"
            case .ruby:
                "ruby"
            }
        }
    }

    enum DisplayShort {
        case none
        case contents
        case block
        case inline
        case runIn
        case flowRoot
        case flow
        case table
        case flex
        case grid
        case ruby
    }

    struct Display: CustomStringConvertible {
        var outer: OuterDisplayType
        var inner: InnerDisplayType?
        var markerBox = false

        init(outer: OuterDisplayType, inner: InnerDisplayType? = nil, markerBox: Bool = false) {
            self.outer = outer
            self.inner = inner
            self.markerBox = markerBox
        }

        init(short: DisplayShort) {
            switch short {
            case .block:
                outer = .block
                inner = .flow
            default:
                DIE("DisplayShort \(short) not implemented")
            }
        }

        func isNone() -> Bool { outer == .none }
        func isContents() -> Bool { outer == .contents }
        func isNoneOrContents() -> Bool { isNone() || isContents() }
        func isFlow() -> Bool { inner == .flow }
        func isInlineOutside() -> Bool { outer == .inline }
        func isFlowInside() -> Bool { inner == .flow }
        func isBlockOutside() -> Bool { outer == .block }
        func isFlowRootInside() -> Bool { inner == .flowRoot }
        func isInlineBlock() -> Bool { outer == .inline && inner == .flowRoot }
        func isFlexInside() -> Bool { inner == .flex }
        func isGridInside() -> Bool { inner == .grid }
        func isTableInside() -> Bool { inner == .table }

        var description: String {
            var result = "\(outer)"
            if let inner {
                if !result.isEmpty {
                    result += " "
                }
                result += "\(inner)"
            }
            if markerBox {
                if !result.isEmpty {
                    result += " "
                }
                result += "marker"
            }
            return result
        }
    }
}

extension CSS.StyleProperties {
    func parseDisplay(context: CSS.ParseContext) -> CSS.StyleValue? {
        let idents = context.parseIndentArray()
        if idents.isEmpty {
            return nil
        }
        var value: CSS.StyleValue? = nil
        if let keyword = parseGlobalKeywords(idents[0]) {
            value = keyword
        } else {
            switch idents.count {
            case 1 where idents[0] == "none":
                value = .display(CSS.Display(outer: .none))
            case 1 where idents[0] == "contents":
                value = .display(CSS.Display(outer: .none))
            case 1 where idents[0] == "block":
                value = .display(CSS.Display(outer: .block, inner: .flow))
            case 1 where idents[0] == "flow-root":
                value = .display(CSS.Display(outer: .block, inner: .flowRoot))
            case 1 where idents[0] == "inline":
                value = .display(CSS.Display(outer: .inline, inner: .flow))
            case 1 where idents[0] == "inline-block":
                value = .display(CSS.Display(outer: .inline, inner: .flowRoot))
            case 1 where idents[0] == "run-in":
                value = .display(CSS.Display(outer: .runIn, inner: .flow))
            case 1 where idents[0] == "list-item":
                value = .display(CSS.Display(outer: .block, inner: .flow, markerBox: true))
            case 2 where idents[0] == "inline" && idents[1] == "list-item":
                value = .display(CSS.Display(outer: .inline, inner: .flow, markerBox: true))
            case 1 where idents[0] == "flex":
                value = .display(CSS.Display(outer: .block, inner: .flex))
            case 1 where idents[0] == "inline-flex":
                value = .display(CSS.Display(outer: .inline, inner: .flex))
            case 1 where idents[0] == "grid":
                value = .display(CSS.Display(outer: .block, inner: .grid))
            case 1 where idents[0] == "inline-grid":
                value = .display(CSS.Display(outer: .inline, inner: .grid))
            case 1 where idents[0] == "ruby":
                value = .display(CSS.Display(outer: .block, inner: .ruby))
            case 1 where idents[0] == "block-ruby":
                value = .display(CSS.Display(outer: .block, inner: .ruby))
            case 1 where idents[0] == "table":
                value = .display(CSS.Display(outer: .block, inner: .table))
            case 2:
                if let outer = CSS.OuterDisplayType(value: idents[0]),
                   let inner = CSS.InnerDisplayType(value: idents[1])
                {
                    value = .display(CSS.Display(outer: outer, inner: inner))
                }
            default:
                break
            }
        }
        return value
    }
}

extension CSS.Display: Equatable {}

extension CSS.Display: CSSPropertyValue {
    typealias T = CSS.Display

    init?(_ styleValue: CSS.StyleValue?) {
        switch styleValue {
        case let .display(display):
            self = display
        case nil:
            return nil
        default:
            FIXME("Unable to convert display from StyleValue: \(styleValue!)")
            return nil
        }
    }

    func styleValue() -> CSS.StyleValue {
        .display(self)
    }
}
