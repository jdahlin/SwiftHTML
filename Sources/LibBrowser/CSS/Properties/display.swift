extension CSS.Properties {
    // https://drafts.csswg.org/css-display/#the-display-properties

    enum Display {
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
    }
}
