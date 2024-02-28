import Foundation

public func browserLoadUrl(url: URL) -> DOM.Document {
    var data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Failed to read \(url): \(error)")
    }

    let document = HTML.parseHTML(&data)
    return document
}
