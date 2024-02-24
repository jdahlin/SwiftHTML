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
        builder.append("\(type(of: layoutNode))<\(tagName)\(identifier)> ")
        if let box = layoutNode as? Layout.Box {
            // FIXME: paintable

            // FIXME: Flex/table
            let paintableBox = box.paintableBox()

            if let b = paintableBox {
                builder.append("at (\(b.absoluteX), \(b.absoluteY)) content-size \(b.contentWidth)x\(b.contentHeight)")
            } else {
                builder.append("(not painted)")
            }

            if box.isInlineBlock() {
                builder.append("(inline-block)")
            }

            if showBoxModel {
                let boxModel = box.boxModel
                let margin = boxModel.margin
                let padding = boxModel.padding
                let border = boxModel.border
                builder.append(" [")
                builder.append("\(margin.left.toInt())+\(border.left.toInt())+\(padding.left.toInt())")
                builder.append(" \(paintableBox?.contentWidth ?? 0) ")
                builder.append("\(padding.right.toInt())+\(border.right.toInt())+\(margin.right.toInt())")
                builder.append("]")

                builder.append(" [")
                builder.append("\(margin.top.toInt())+\(border.top.toInt())+\(padding.top.toInt())")
                builder.append(" \(paintableBox?.contentHeight ?? 0) ")
                builder.append("\(padding.bottom.toInt())+\(border.bottom.toInt())+\(margin.bottom.toInt())")
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
