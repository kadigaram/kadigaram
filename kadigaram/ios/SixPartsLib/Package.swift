// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SixPartsLib",
    platforms: [
        .iOS(.v16)  // Support iOS 16+ per constitution
    ],
    products: [
        .library(
            name: "SixPartsLib",
            targets: ["SixPartsLib"]),
    ],
    dependencies: [
        // Solar library for sunrise/sunset calculations
        .package(url: "https://github.com/ceeK/Solar.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "SixPartsLib",
            dependencies: [
                .product(name: "Solar", package: "Solar"),
            ]
        ),
        .testTarget(
            name: "SixPartsLibTests",
            dependencies: ["SixPartsLib"]),
    ]
)
