
extension CSS {
    enum Property<T>: CustomStringConvertible {
        case set(T)
        case inherited
        case initial
        case revert
        case revertLayer
        case unset

        var description: String {
            switch self {
            case let .set(value):
                "\(value)"
            case .inherited:
                "inherited"
            case .initial:
                "initial"
            case .revert:
                "revert"
            case .revertLayer:
                "revertLayer"
            case .unset:
                "unset"
            }
        }
    }

    struct Dimension: CustomStringConvertible {
        var number: CSS.Number
        var unit: CSS.Unit.Length

        var description: String {
            "\(number)\(unit)"
        }
    }

    enum LengthOrPercentage: CustomStringConvertible {
        case length(Dimension)
        case percentage(Number)
        case auto

        var description: String {
            switch self {
            case let .length(dimension):
                "\(dimension)"
            case let .percentage(number):
                "\(number)%"
            case .auto:
                "auto"
            }
        }
    }

    enum BorderStyle {
        case none
        case hidden
        case dotted
        case dashed
        case solid
        case double
        case groove
        case ridge
        case inset
        case outset

        init(value: String) {
            switch value {
            case "none":
                self = .none
            case "hidden":
                self = .hidden
            case "dotted":
                self = .dotted
            case "dashed":
                self = .dashed
            case "solid":
                self = .solid
            case "double":
                self = .double
            case "groove":
                self = .groove
            case "ridge":
                self = .ridge
            case "inset":
                self = .inset
            case "outset":
                self = .outset
            default:
                DIE("border-style: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .none:
                "none"
            case .hidden:
                "hidden"
            case .dotted:
                "dotted"
            case .dashed:
                "dashed"
            case .solid:
                "solid"
            case .double:
                "double"
            case .groove:
                "groove"
            case .ridge:
                "ridge"
            case .inset:
                "inset"
            case .outset:
                "outset"
            }
        }
    }

    enum LineWidth: CustomStringConvertible {
        case thin
        case medium
        case thick

        init(value: String) {
            switch value {
            case "thin":
                self = .thin
            case "medium":
                self = .medium
            case "thick":
                self = .thick
            default:
                DIE("line-width: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .thin:
                "thin"
            case .medium:
                "medium"
            case .thick:
                "thick"
            }
        }
    }

    enum BorderWidth: CustomStringConvertible {
        case lineWidth(LineWidth)
        case length(Dimension)

        var description: String {
            switch self {
            case let .lineWidth(lineWidth):
                "\(lineWidth)"
            case let .length(dimension):
                "\(dimension)"
            }
        }
    }

    // https://drafts.csswg.org/css-display/#the-display-properties
    enum Display: CustomStringConvertible {
        case block
        case inline
        case runIn
        case flow
        case flowRoot
        case table
        case flex
        case grid
        case ruby
        case listItem
        case listItemBlock
        case listItemInline
        case listItemInlineBlock
        case tableRowGroup
        case tableHeaderGroup
        case tableFooterGroup
        case tableRow
        case tableCell
        case tableColumnGroup
        case tableColumn
        case tableCaption
        case rubyBase
        case rubyText
        case rubyBaseContainer
        case rubyTextContainer
        case contents
        case none
        case inlineBlock
        case inlineTable
        case inlineFlex
        case inlineGrid
        init(value: String) {
            switch value {
            case "block": self = .block
            case "inline": self = .inline
            case "run-in": self = .runIn
            case "flow": self = .flow
            case "flow-root": self = .flowRoot
            case "table": self = .table
            case "flex": self = .flex
            case "grid": self = .grid
            case "ruby": self = .ruby
            case "list-item": self = .listItem
            case "list-item-block": self = .listItemBlock
            case "list-item-inline": self = .listItemInline
            case "list-item-inline-block": self = .listItemInlineBlock
            case "table-row-group": self = .tableRowGroup
            case "table-header-group": self = .tableHeaderGroup
            case "table-footer-group": self = .tableFooterGroup
            case "table-row": self = .tableRow
            case "table-cell": self = .tableCell
            case "table-column-group": self = .tableColumnGroup
            case "table-column": self = .tableColumn
            case "table-caption": self = .tableCaption
            case "ruby-base": self = .rubyBase
            case "ruby-text": self = .rubyText
            case "ruby-base-container": self = .rubyBaseContainer
            case "ruby-text-container": self = .rubyTextContainer
            case "contents": self = .contents
            case "none": self = .none
            case "inline-block": self = .inlineBlock
            case "inline-table": self = .inlineTable
            case "inline-flex": self = .inlineFlex
            case "inline-grid": self = .inlineGrid
            default:
                self = .inline // Default value
            }
        }

        static func fromString(value: String) -> Self {
            switch value {
            case "block": .block
            case "inline": .inline
            case "run-in": .runIn
            case "flow": .flow
            case "flow-root": .flowRoot
            case "table": .table
            case "flex": .flex
            case "grid": .grid
            case "ruby": .ruby
            case "list-item": .listItem
            case "list-item-block": .listItemBlock
            case "list-item-inline": .listItemInline
            case "list-item-inline-block": .listItemInlineBlock
            case "table-row-group": .tableRowGroup
            case "table-header-group": .tableHeaderGroup
            case "table-footer-group": .tableFooterGroup
            case "table-row": .tableRow
            case "table-cell": .tableCell
            case "table-column-group": .tableColumnGroup
            case "table-column": .tableColumn
            case "table-caption": .tableCaption
            case "ruby-base": .rubyBase
            case "ruby-text": .rubyText
            case "ruby-base-container": .rubyBaseContainer
            case "ruby-text-container": .rubyTextContainer
            case "contents": .contents
            case "none": .none
            case "inline-block": .inlineBlock
            case "inline-table": .inlineTable
            case "inline-flex": .inlineFlex
            case "inline-grid": .inlineGrid
            default:
                .inline // Default value
            }
        }

        var description: String {
            switch self {
            case .block: "block"
            case .inline: "inline"
            case .runIn: "run-in"
            case .flow: "flow"
            case .flowRoot: "flow-root"
            case .table: "table"
            case .flex: "flex"
            case .grid: "grid"
            case .ruby: "ruby"
            case .listItem: "list-item"
            case .listItemBlock: "list-item-block"
            case .listItemInline: "list-item-inline"
            case .listItemInlineBlock: "list-item-inline-block"
            case .tableRowGroup: "table-row-group"
            case .tableHeaderGroup: "table-header-group"
            case .tableFooterGroup: "table-footer-group"
            case .tableRow: "table-row"
            case .tableCell: "table-cell"
            case .tableColumnGroup: "table-column-group"
            case .tableColumn: "table-column"
            case .tableCaption: "table-caption"
            case .rubyBase: "ruby-base"
            case .rubyText: "ruby-text"
            case .rubyBaseContainer: "ruby-base-container"
            case .rubyTextContainer: "ruby-text-container"
            case .contents: "contents"
            case .none: "none"
            case .inlineBlock: "inline-block"
            case .inlineTable: "inline-table"
            case .inlineFlex: "inline-flex"
            case .inlineGrid: "inline-grid"
            }
        }
    }

    typealias Margin = LengthOrPercentage
    typealias Padding = LengthOrPercentage

    enum RectangularShorthand<T>: CustomStringConvertible {
        case one(T)
        case two(topBottom: T, leftRight: T)
        case three(top: T, leftRight: T, bottom: T)
        case four(top: T, right: T, bottom: T, left: T)

        var description: String {
            switch self {
            case let .one(value):
                "\(value)"
            case let .two(topBottom, leftRight):
                "\(topBottom) \(leftRight)"
            case let .three(top, leftRight, bottom):
                "\(top) \(leftRight) \(bottom)"
            case let .four(top, right, bottom, left):
                "\(top) \(right) \(bottom) \(left)"
            }
        }
    }

    struct PropertyValues {
        var backgroundColor: Property<CSS.Color> = .initial
        var borderStyle: Property<RectangularShorthand<CSS.BorderStyle>> = .initial
        var borderWidth: Property<RectangularShorthand<CSS.BorderWidth>> = .initial
        var display: Property<CSS.Display> = .initial
        var color: Property<CSS.Color> = .initial
        var margin: Property<RectangularShorthand<Margin>> = .initial
        var padding: Property<RectangularShorthand<Padding>> = .initial

        mutating func parseCSSValue(name: String, value valueWithWhitespace: [CSS.ComponentValue]) {
            let value: [CSS.ComponentValue] = valueWithWhitespace.filter {
                if case .token(.whitespace) = $0 {
                    return false
                }
                return true
            }
            switch name {
            case "background-color":
                backgroundColor = parseColor(value: value)
            case "border-style":
                borderStyle = parseBorderStyle(value: value)
            case "border-width":
                borderWidth = parseBorderWidth(value: value)
            case "color":
                color = parseColor(value: value)
            case "display":
                display = parseDisplay(value: value)
            case "margin":
                margin = parseMargin(value: value)
            case "padding":
                padding = parsePadding(value: value)
            default:
                FIXME("\(name): \(value) not implemented")
            }
        }
    }

    static func parseBorderStyle(value: [CSS.ComponentValue]) -> Property<RectangularShorthand<BorderStyle>> {
        func parse(value: CSS.ComponentValue) -> BorderStyle {
            switch value {
            case let .token(.ident(ident)):
                BorderStyle(value: ident)
            default:
                DIE("border-style value: \(value) not implemented")
            }
        }
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("border-style value: \(value) not implemented")
        }
        return .initial
    }

    static func parseBorderWidth(value: [CSS.ComponentValue]) -> CSS.Property<RectangularShorthand<BorderWidth>> {
        func parse(value: CSS.ComponentValue) -> BorderWidth {
            switch value {
            case let .token(.ident(ident)):
                .lineWidth(LineWidth(value: ident))
            case let .token(.dimension(number: number, unit: unit)):
                .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
            default:
                DIE("border-width value: \(value) not implemented")
            }
        }
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("border-width value: \(value) not implemented")
        }
        return .initial
    }

    static func parseColor(value: [CSS.ComponentValue]) -> CSS.Property<CSS.Color> {
        guard value.count == 1 else {
            FIXME("color value: \(value) not implemented")
            return .initial
        }
        switch value[0] {
        case let .token(.ident(name)):
            return .set(CSS.Color.named(CSS.Color.Named(string: name)))
        default:
            DIE("color value: \(value) not implemented")
        }
    }

    static func parseDimension(value: [CSS.ComponentValue]) -> CSS.Number? {
        switch value.count {
        case 1:
            switch value[0] {
            case let .token(.dimension(number: number)):
                return number.number
            default:
                break
            }
        default:
            break
        }
        FIXME("dimension value: \(value) not implemented")
        return nil
    }

    static func parseDisplay(value: [CSS.ComponentValue]) -> Property<Display> {
        if value.count == 1 {
            switch value[0] {
            case let .token(.ident(name)):
                return .set(Display(value: name))
            default:
                FIXME("display value: \(value) not implemented")
            }
        } else {
            FIXME("display value: \(value) not implemented")
        }
        return .initial
    }

    static func parseMargin(value: [CSS.ComponentValue]) -> Property<RectangularShorthand<Margin>> {
        func parse(value: CSS.ComponentValue) -> Margin {
            switch value {
            case .token(.ident("auto")):
                .auto
            case let .token(.dimension(number: number, unit: unit)):
                .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
            default:
                DIE("margin value: \(value) not implemented")
            }
        }
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("margin value: \(value) not implemented")
        }
        return .initial
    }

    static func parsePadding(value: [CSS.ComponentValue]) -> Property<RectangularShorthand<Padding>> {
        func parse(value: CSS.ComponentValue) -> Padding {
            switch value {
            case .token(.ident("auto")):
                .auto
            case let .token(.dimension(number: number, unit: unit)):
                .length(Dimension(number: number, unit: CSS.Unit.Length(unit: unit)))
            default:
                DIE("padding value: \(value) not implemented")
            }
        }
        switch value.count {
        case 1:
            return .set(.one(parse(value: value[0])))
        case 2:
            return .set(.two(
                topBottom: parse(value: value[0]),
                leftRight: parse(value: value[1])
            ))
        case 3:
            return .set(.three(
                top: parse(value: value[0]),
                leftRight: parse(value: value[1]),
                bottom: parse(value: value[2])
            ))
        case 4:
            return .set(.four(
                top: parse(value: value[0]),
                right: parse(value: value[1]),
                bottom: parse(value: value[2]),
                left: parse(value: value[3])
            ))
        default:
            FIXME("padding value: \(value) count=\(value.count) not implemented")
        }
        return .initial
    }
}
