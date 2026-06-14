// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ViewMD",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.4.0"),
    ],
    targets: [
        .executableTarget(
            name: "ViewMD",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
            ],
            resources: [
                .copy("Resources/template.html"),
                .copy("Resources/pdf-style.css"),
                .copy("Resources/highlight.css"),
                .copy("Resources/mermaid.min.js"),
            ]
        ),
        .testTarget(
            name: "ViewMDTests",
            dependencies: ["ViewMD"],
            path: "Tests/ViewMDTests"
        ),
    ]
)
