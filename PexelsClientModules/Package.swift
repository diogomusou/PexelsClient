// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PexelsClientModules",
    platforms: [.iOS("17.6")],
    products: [
        .library(name: "API", targets: ["API"]),
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "PhotoFullscreenFeature", targets: ["PhotoFullscreenFeature"]),
        .library(name: "PhotosListFeature", targets: ["PhotosListFeature"]),
        .library(name: "UI", targets: ["UI"]),
    ],
    targets: [
        .target(
            name: "API"
        ),
        .target(
            name: "Extensions"
        ),
        .target(
            name: "PhotoFullscreenFeature",
            dependencies: [
                "API",
                "Extensions",
                "UI"
            ]
        ),
        .target(
            name: "PhotosListFeature",
            dependencies: [
                "API",
                "Extensions",
                "PhotoFullscreenFeature",
                "UI"
            ]
        ),
        .target(
            name: "UI",
            dependencies: [
                "Extensions",
            ]
        ),
        .testTarget(
            name: "ExtensionsTests",
            dependencies: ["Extensions"]
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
