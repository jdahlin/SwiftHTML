extension CSS {
    // https://drafts.csswg.org/css-display/#the-display-properties
    enum Display: CustomStringConvertible, EnumStringInit {
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
}
