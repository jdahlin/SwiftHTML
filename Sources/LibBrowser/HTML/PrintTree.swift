extension DOM {
    static func printTree(node: DOM.Node, indent: String = "") {
        switch node {
        case let text as DOM.Text:
            print(indent + "\"" + text.data + "\"")
        case is DOM.DocumentType:
            print(indent + "#doctype")
        case is DOM.Document:
            print(indent + "#document")
            for node in node.childNodes {
                printTree(node: node, indent: indent + "  ")
            }
        default:
            let nodeName = node.nodeName?.lowercased() ?? "nil"
            var extra = ""
            if let element = node as? DOM.Element, element.attributes.length > 0 {
                for i in 0 ..< element.attributes.length {
                    if let attr = element.attributes.item(i) {
                        extra += " \(attr.name)=\(attr.value)"
                    }
                }
            }
            print(indent + "<\(nodeName)\(extra)>")
            for node in node.childNodes {
                printTree(node: node, indent: indent + "  ")
            }
        }
    }
}

extension Layout {
    static func printTree(layoutNode: Layout.Node,
                          indent: String = "",
                          showBoxModel: Bool = true)
    {
        let tagName: String = if layoutNode.isAnonymous() {
            "(anonymous)"
        } else if let element = layoutNode.domNode as? DOM.Element {
            element.localName
        } else {
            layoutNode.domNode!.nodeName!
        }

        var identifier = ""
        if let element = layoutNode.domNode as? DOM.Element {
            if !element.id.isEmpty {
                identifier.append("#\(element.id)")
            }
            for className in element.classList {
                identifier.append(".\(className)")
            }
        }

        if let text = layoutNode.domNode as? DOM.Text {
            let data = text.data.replacingOccurrences(of: "\n", with: "\\n")
            identifier.append(" \"\(data)\"")
        }

        var builder = ""
        builder.append("\(type(of: layoutNode))<\(tagName)\(identifier)>")
        if let box = layoutNode as? Layout.Box {
            // FIXME: paintable

            if box.isInlineBlock() {
                builder.append("(inline-block)")
            }
            // FIXME: Flex/table

            if showBoxModel {
                let boxModel = box.boxModel
                let margin = boxModel.margin
                let padding = boxModel.padding
                let border = boxModel.border
                builder.append("[")
                builder.append("\(margin.left)+\(border.left)+\(padding.left)")
                builder.append(" \(box.computedValues.width) ")
                builder.append("\(padding.right)+\(border.right)+\(margin.right)")
                builder.append("]")

                builder.append(" [")
                builder.append("\(margin.top)+\(border.top)+\(padding.top)")
                builder.append(" ??? ")
                builder.append("\(padding.bottom)+\(border.bottom)+\(margin.bottom)")
                builder.append("]")
            }

            switch FormattingContext.formattingContextTypeCreatedByBox(box) {
            case .block:
                builder.append(" [BFC]")
            case .inline:
                builder.append(" [IFC]")
            case .table:
                builder.append(" [TFC]")
            case .flex:
                builder.append(" [FFC]")
            case .grid:
                builder.append(" [GFC]")
            case .none:
                break
            }
            builder.append(" children: \(box.childrenAreInline ? "inline" : "not-inline")")
        }
        // builder.append("\n")

        // FIXME: fragments (textnode, blockcontainer, inline)

        print(indent + builder)
        for child in layoutNode.children {
            printTree(layoutNode: child, indent: indent + "  ", showBoxModel: showBoxModel)
        }
    }
}
