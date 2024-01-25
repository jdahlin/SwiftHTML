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

extension HTML {
    static func parseHTML(_ data: inout Data) -> DOM.Document {
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
        HTML.normalizeNewlines(&data)

        let tokenizer = HTML.Tokenizer(data: data)
        let treeBuilder = HTML.TreeBuilder(tokenizer: tokenizer)

        tokenizer.tokenize()

        return treeBuilder.document
    }
}
