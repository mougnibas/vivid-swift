// swift-tools-version: 6.1.0

import PackageDescription

let package = Package(

    // Name of the package.
    name: "VividCommon",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividCommon",
            targets: ["VividCommon"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1")
    ],

    // We have the following targets.
    targets: [

        // Main target, without any dependencies.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividCommon",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),

        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividCommonTests",
            dependencies: ["VividCommon"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        )
    ]
)
