import Foundation

public func testEntrypoint() {
    // let filename = FileManager.default.currentDirectoryPath + "/Resources/CSS/default.css"
    // print(filename)
    // _ = Result {
    //     try CSS.parseAStylesheet(filename: filename)
    // }
    let filename = FileManager.default.currentDirectoryPath + "/Resources/HTML/example112.html"
    let url = URL(fileURLWithPath: filename)
    var data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Failed to read \(url): \(error)")
    }

    let document = HTML.parseHTML(&data)
    // DOM.printTree(node: document)
    _ = document
}
