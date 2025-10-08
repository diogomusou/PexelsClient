// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PexelsClientModules",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PexelsClientModules",
            targets: ["PexelsClientModules"]
        ),
    ],
    targets: [
        .target(
            name: "PexelsClientModules"
        ),
        .testTarget(
            name: "PexelsClientModulesTests",
            dependencies: ["PexelsClientModules"]
        ),
    ]
)
