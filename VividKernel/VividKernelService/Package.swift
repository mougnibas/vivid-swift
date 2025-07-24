// swift-tools-version: 6.1.0

import PackageDescription

// Only enable swiftlint (package and plugin) if running from macOS (can't be run as plugin outside of macOS).
#if os(macOS)
let packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1")
]
let swiftLintPlugins: [Target.PluginUsage] = [
    .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
]
#else
let packageDependencies: [Package.Dependency] = []
let swiftLintPlugins: [Target.PluginUsage] = []
#endif


let package = Package(

    // Name of the package.
    name: "VividKernelService",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15),
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelService",
            targets: ["VividKernelService"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies:

        // Public dependencies.
        packageDependencies,

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelService",
            plugins: swiftLintPlugins
        ),

        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividKernelServiceTests",
            dependencies: ["VividKernelService"],
            plugins: swiftLintPlugins
        )
    ]
)
