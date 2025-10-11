// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PexelsClientModules",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "API", targets: ["API"]),
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "PhotosListFeature", targets: ["PhotosListFeature"]),
    ],
    targets: [
        .target(
            name: "API"
        ),
        .target(
            name: "Extensions"
        ),
        .target(
            name: "PhotosListFeature",
            dependencies: [
                "API",
                "Extensions"
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
