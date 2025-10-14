// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PexelsClientModules",
    platforms: [.iOS("17.6")],
    products: [
        .library(name: "API", targets: ["API"]),
        .library(name: "APILive", targets: ["APILive"]),
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "PhotoFullscreenFeature", targets: ["PhotoFullscreenFeature"]),
        .library(name: "PhotosListFeature", targets: ["PhotosListFeature"]),
        .library(name: "UI", targets: ["UI"]),
    ],
    dependencies: [
        .package(url: "git@github.com:pointfreeco/swift-concurrency-extras.git", exact: "1.3.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0")
    ],
    targets: [
        .target(
            name: "API",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
        ),
        .target(
            name: "APILive",
            dependencies: [
                "API",
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .target(
            name: "Extensions",
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .target(
            name: "Models",
        ),
        .target(
            name: "PhotoFullscreenFeature",
            dependencies: [
                "API",
                "Extensions",
                "Models",
                "UI",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .target(
            name: "PhotosListFeature",
            dependencies: [
                "API",
                "Extensions",
                "Models",
                "PhotoFullscreenFeature",
                "UI",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .target(
            name: "UI",
            dependencies: [
                "Extensions",
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "ExtensionsTests",
            dependencies: ["Extensions"]
        ),
        .testTarget(
            name: "PhotoFullscreenFeatureTests",
            dependencies: [
                "API",
                "Models",
                "PhotoFullscreenFeature",
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PhotosListFeatureTests",
            dependencies: [
                "API",
                "PhotosListFeature"
            ]
        ),

    ]
)
