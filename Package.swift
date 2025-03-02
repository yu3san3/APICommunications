// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "APICommunications",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "APICommunications",
            targets: ["APICommunications"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/yu3san3/PrettyFormatter",
            .upToNextMajor(from: "0.1.0")
        )
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
