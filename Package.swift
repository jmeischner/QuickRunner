// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickRunner",
    products: [
        .executable(name: "QuickRunner", targets: ["QuickRunner"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "QuickRunner",
            dependencies: ["QuickRunnerCore", "Rainbow", "Commander"]),
        .target(
            name: "QuickRunnerCore",
            dependencies: ["Helper"]),
        .testTarget(
            name: "QuickRunnerCoreTests",
            dependencies: ["QuickRunnerCore", "Quick", "Nimble"]),
        .target(
            name: "Helper",
            dependencies: ["Rainbow"]),
        .testTarget(
            name: "HelperTests",
            dependencies: ["Helper", "Quick", "Nimble"])
    ]
)
