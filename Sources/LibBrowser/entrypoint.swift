import Foundation

// func cssParse() {
//     let cssString = """
//     tag {width: url('http://example.com'); height: calc(1 + 1)}

//     .class {}

//     #id {}

//     * {}

//     :pseudo {}

//     [attr] {}

//     [attr=value] {}
//     [attr=value i] {}
//     [attr^=value i] {}
//     compound#selector {}
//     child anscestor {}
//     child>parent {}
//     sibling~subsequent-sibling {}
//     child+next-sibling {}
//     """
//     for raw in cssString.components(separatedBy: "\n") {
//         if raw.isEmpty {
//             continue
//         }
//         var tokenStream = CSS.TokenStream(raw)
//         var parsedStyleSheet: CSS.ParsedStyleSheet?
//         do {
//             parsedStyleSheet = try CSS.parseAStylesheet(&tokenStream)
//             // Handle the parsed stylesheet here
//         } catch {
//             // Handle the error thrown during parsing
//             print("Error: \(error)")
//             return
//         }

//         for case let .qualified(qualifiedRule) in parsedStyleSheet!.rules {
//             print(raw)
//             print(qualifiedRule.prelude, qualifiedRule.simpleBlock.value)
//             print(consumeSelectorList(qualifiedRule.prelude))
//             print("=============")
//             //    for case .simpleBlock(let block) in qualifiedRule.prelude {
//             //        for case .token(let token) in block.value {
//             //            print(token)
//             //        }
//             //    }
//         }
//     }
// }

public func testEntrypoint() {
    // let html =
    //     "<!doctype html><html><head><title>Test</title></head><body double=\"one\" single='two' unquoted=three><p>Hello, world!</p><!-- foo --></body></html>\r\n"
    let html = """
    <html>
      <head>
        <script>console.log("Hello World!")</script>
        <style>div { color: white }</style>
      </head>
      <body>
      1
      <div id=mine class=foo>2</div>
      <span>Span2</span>
      <span>Paragraph</span>
      3
      </body>
      </html>
    """
    let filename = FileManager.default.currentDirectoryPath + "/Sources/CSS/default.css"
    print(filename)
    _ = Result {
        try CSS.parseAStylesheet(filename: filename)
    }
    var data = Data(html.utf8)
    let document = HTML.parseHTML(&data)
    let post = String(decoding: data, as: UTF8.self)
    print(post)
    DOM.printTree(document)
    let elements = document.body!.querySelectorAll("*")
    print(elements)
}
