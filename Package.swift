// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HelloWorldSwift",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/elementary-swift/elementary-ui", exact: "0.1.8"),
    ],
    targets: [
        .executableTarget(
            name: "HelloWorldSwift",
            dependencies: [
                .product(name: "ElementaryUI", package: "elementary-ui"),
            ]
        ),
    ]
)
