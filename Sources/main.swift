// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import JavaScriptCore

func FIXME(
    _ message: String? = nil,
    function: String = #function,
    file: String = #fileID,
    line: Int = #line
) {
    print("FIXME: \(message ?? "") in \(function) at \(file):\(line)")
}

func DIE(
    _ message: String? = nil,
    function: String = #function,
    file: String = #fileID,
    line: Int = #line
) -> Never {
    print("DIE: \(message ?? "") in \(function) at \(file):\(line)")
    exit(1)
}

func parseHTML(_ data: inout Data) -> Document {
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

func printDOMTree(_ node: Node, _ indent: String = "") {
    for child in node.childNodes {
        switch child {
        case is Text:
            let text = child as! Text
            print(indent + text.data.debugDescription)
        default:
            let nodeName = child.nodeName ?? "nil"
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

// let html =
//     "<!doctype html><html><head><title>Test</title></head><body double=\"one\" single='two' unquoted=three><p>Hello, world!</p><!-- foo --></body></html>\r\n"
let html =
    "<html><head></head><body>1<div class=foo>2</div>3</body></html>"
var data = Data(html.utf8)
let document = parseHTML(&data)
let post = String(decoding: data, as: UTF8.self)
print(post)
printDOMTree(document)
