// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KadigaramCore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KadigaramCore",
            targets: ["KadigaramCore"]
        ),
    ],
    dependencies: [
        // Solar - Sunrise/sunset calculations (Naval Observatory algorithm)
        .package(url: "https://github.com/ceeK/Solar.git", from: "3.0.0"),
        // SixPartsLib - Vedic and Tamil calendar calculations (local package)
        .package(path: "../SixPartsLib"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KadigaramCore",
            dependencies: [
                .product(name: "Solar", package: "Solar"),
                .product(name: "SixPartsLib", package: "SixPartsLib"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "KadigaramCoreTests",
            dependencies: ["KadigaramCore"]
        ),
    ]
)

