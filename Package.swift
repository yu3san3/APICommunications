// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "APICommunications",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "APICommunications",
            targets: ["APICommunications"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/yu3san3/PrettyFormatter", branch: "main")
    ],
    targets: [
        .target(
            name: "APICommunications",
            dependencies: ["PrettyFormatter"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "APICommunicationsTests",
            dependencies: ["APICommunications"]
        ),
    ]
)
