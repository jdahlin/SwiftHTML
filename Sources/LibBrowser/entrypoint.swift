import Foundation

public func browserLoadUrl(url: URL) {
    var data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Failed to read \(url): \(error)")
    }

    let document = HTML.parseHTML(&data)
    // DOM.printTree(node: document)
    if document.documentElement != nil {
        // print("------ HTML ------")
        // let style = document.styleComputer.computeStyle(element: element)
        // print(style.toStringDict())
        // print("------ BODY ------")
        // let style2 = document.styleComputer.computeStyle(element: document.body!)
        // print(style2.toStringDict())

        document.updateLayout()
    }
}
