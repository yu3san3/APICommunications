// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "APICommunications",
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
    targets: [
        .target(
            name: "APICommunications"
        ),
        .testTarget(
            name: "APICommunicationsTests",
            dependencies: ["APICommunications"]
        ),
    ]
)
