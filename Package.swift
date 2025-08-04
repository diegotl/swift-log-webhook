// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "WebhookLogging",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "WebhookLogging",
            targets: ["WebhookLogging"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "WebhookLogging",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "WebhookLoggingTests",
            dependencies: ["WebhookLogging"]
        )
    ]
)
