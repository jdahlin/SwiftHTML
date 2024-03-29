// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHTML",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "LibBrowser", targets: ["LibBrowser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git",
                 .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "LibBrowser",
                dependencies: [
                    .product(name: "Collections", package: "swift-collections"),
                ],
                path: "Sources/LibBrowser",
                resources: [
                    .process("Resources/HTML"),
                    .process("Resources/CSS"),
                ]),
        .executableTarget(name: "Browser", dependencies: ["LibBrowser"], path: "Sources/Browser"),
    ],
    swiftLanguageVersions: [.v5]
)
