import AppKit

import LibBrowser

class BrowserView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Direct drawing here
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        context.setFillColor(NSColor.white.cgColor)
        context.fill(bounds)

        // Drawing a circle
        let circlePath = NSBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 80, height: 80))
        NSColor.blue.setFill()
        circlePath.fill()

        let text = "Hello, world!"
        let fontName = "Helvetica"
        let fontSize: CGFloat = 14.0
        let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
        let string = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        string.draw(at: NSPoint(x: 100, y: 100))
    }
}

class BrowserViewController: NSViewController {
    override func loadView() {
        view = BrowserView()

        let url = URL(fileURLWithPath: "/Users/johandahlin/dev/SwiftHTML/Resources/HTML/simple.html")
        LibBrowser.browserLoadUrl(url: url)
        // terminate app immediately
        NSApp.terminate(nil)
        view.wantsLayer = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let browserView = BrowserView(frame: view.bounds)
        browserView.autoresizingMask = [.width, .height]
        view.addSubview(browserView)
    }
}
