// The Swift Programming Language
// https://docs.swift.org/swift-book

import Cocoa

import AppKit

class BrowserAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!

    func createMainWindow() {
        let windowRect = NSRect(x: 0, y: 0, width: 1024, height: 768)
        window = NSWindow(contentRect: windowRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        window.title = "Browser"
        window.makeKeyAndOrderFront(nil)
        window.delegate = self
    }

    func createMenus() {
        let mainMenu = NSMenu()

        // Create the app menu ()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        // Add items to the app menu
        appMenu.addItem(withTitle: "About My App", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())

        // Preferences, if needed
        // appMenu.addItem(withTitle: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")

        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit My App", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        // Set the main menu
        NSApp.mainMenu = mainMenu
    }

    func createBrowserView() {
        let viewController = BrowserViewController()
        window.contentView = viewController.view
    }

    func applicationDidFinishLaunching(_: Notification) {
        createMainWindow()
        createMenus()
        createBrowserView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}

class BrowserApplication: NSApplication {
    let strongDelegate = BrowserAppDelegate()

    override init() {
        super.init()
        delegate = strongDelegate
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let application = BrowserApplication.shared
application.run()
