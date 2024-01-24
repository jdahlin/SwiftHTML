import Foundation

package func FIXME(
    _ message: String? = nil,
    function: String = #function,
    file: String = #fileID,
    line: Int = #line
) {
    print("FIXME: \(message ?? "") in \(function) at \(file):\(line)")
}

package func DIE(
    _ message: String? = nil,
    function: String = #function,
    file: String = #fileID,
    line: Int = #line
) -> Never {
    print("DIE: \(message ?? "") in \(function) at \(file):\(line)")
    exit(1)
}

public func parseHTML(_ data: inout Data) -> Document {
    // let context = JSContext()
    // if let globalObject = context?.evaluateScript("this") {
    //   print(type(of: globalObject))
    // }

    // FIXME: determine encoding properly
    //   let encoding = String.Encoding.utf8
    //   let byteStream = ByteStream(data: data)

    // Before the tokenization stage, the input stream must be preprocessed by
    // normalizing newlines. Thus, newlines in HTML DOMs are represented by U+000A
    // LF characters, and there are never any U+000D CR characters in the input to
    // the tokenization stage.
    normalizeNewlines(&data)

    let tokenizer = Tokenizer(data: data)
    let treeBuilder = TreeBuilder(tokenizer: tokenizer)

    tokenizer.tokenize()

    return treeBuilder.document
}

public func printDOMTree(_ node: Node, _ indent: String = "") {
    for child in node.childNodes {
        switch child {
        case is Text:
            let text = child as! Text
            print(indent + text.data.debugDescription)
        default:
            let nodeName = child.nodeName?.lowercased() ?? "nil"
            var extra = ""
            if let element = child as? Element, element.attributes.length > 0 {
                for i in 0 ..< element.attributes.length {
                    if let attr = element.attributes.item(i) {
                        extra += " \(attr.name)=\"\(attr.value)\""
                    }
                }
            }
            print(indent + "<\(nodeName)\(extra)>")
            printDOMTree(child, indent + "  ")
            print(indent + "</\(nodeName)>")
        }
    }
}
