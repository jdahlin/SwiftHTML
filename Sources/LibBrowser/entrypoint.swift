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

let cssExample122 = """
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<HTML>
  <HEAD>
    <TITLE>Examples of margins, padding, and borders</TITLE>
    <STYLE type="text/css">
      UL {
        background: yellow;
        margin: 12px 12px 12px 12px;
        padding: 3px 3px 3px 3px;
                                     /* No borders set */
      }
      LI {
        color: white;                /* text color is white */
        background: blue;            /* Content, padding will be blue */
        margin: 12px 12px 12px 12px;
        padding: 12px 0px 12px 12px; /* Note 0px padding right */
        list-style: none             /* no glyphs before a list item */
                                     /* No borders set */
      }
      LI.withborder {
        border-style: dashed;
        border-width: medium;        /* sets border width on all sides */
        border-color: lime;
      }
    </STYLE>
  </HEAD>
  <BODY>
    <UL>
      <LI>First element of list
      <LI class="withborder">Second element of list is
           a bit longer to illustrate wrapping.
    </UL>
  </BODY>
</HTML>
"""

public func testEntrypoint() {
    // let html =
    //     "<!doctype html><html><head><title>Test</title></head><body double=\"one\" single='two' unquoted=three><p>Hello, world!</p><!-- foo --></body></html>\r\n"
    let html = cssExample122
    // let filename = FileManager.default.currentDirectoryPath + "/Resources/CSS/default.css"
    // print(filename)
    // _ = Result {
    //     try CSS.parseAStylesheet(filename: filename)
    // }
    var data = Data(html.utf8)
    let document = HTML.parseHTML(&data)
    DOM.printTree(node: document)
    // let elements = document.body!.querySelectorAll("*")
    // print(elements)
}
