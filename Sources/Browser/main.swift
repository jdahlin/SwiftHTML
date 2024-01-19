// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import HTML
import JavaScriptCore

@main
class Browser {
  static func main() {
    // let html =
    //     "<!doctype html><html><head><title>Test</title></head><body double=\"one\" single='two' unquoted=three><p>Hello, world!</p><!-- foo --></body></html>\r\n"
    let html =
      "<html><head></head><body>1<div class=foo>2</div>3</body></html>"
    var data = Data(html.utf8)
    let document = HTML.parseHTML(&data)
    let post = String(decoding: data, as: UTF8.self)
    print(post)
    HTML.printDOMTree(document)
  }
}
