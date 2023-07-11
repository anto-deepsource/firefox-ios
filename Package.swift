// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Danger",
    platforms: [.iOS("15"), .macOS("11")],
    products: [
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", exact: "3.16.0"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage2", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage3", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage4", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage5", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage6", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage7", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage8", exact: "1.2.1"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage9", exact: "1.2.1"), // dev
    ],
    targets: [
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "swift"),
                .product(name: "DangerSwiftCoverage", package: "danger-swift-coverage")
            ]
        ) // dev
    ]
)
