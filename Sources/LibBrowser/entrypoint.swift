import Foundation

public func browserLoadUrl(url _: String) {
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
    if let element = document.documentElement {
        // print("------ HTML ------")
        // let style = document.styleComputer.computeStyle(element: element)
        // print(style.toStringDict())
        // print("------ BODY ------")
        // let style2 = document.styleComputer.computeStyle(element: document.body!)
        // print(style2.toStringDict())

        document.updateLayout()
    }
}
