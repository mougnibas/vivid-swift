// swift-tools-version: 6.1.0

import PackageDescription

// Only enable swiftlint (package and plugin) if running from macOS (can't be run as plugin outside of macOS).
#if os(macOS)
let swiftLintDependency: [Package.Dependency] = [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1")
]
let swiftLintPlugins: [Target.PluginUsage] = [
    .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
]
#else
let swiftLintDependency: [Package.Dependency] = []
let swiftLintPlugins: [Target.PluginUsage] = []
#endif

let package = Package(

    // Name of the package.
    name: "VividKernelDataAccessService",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelDataAccessService",
            targets: ["VividKernelDataAccessService"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: swiftLintDependency + [
        
        // Private dependencies.
        .package(path: "../VividKernelService"),
    ],

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelDataAccessService",
            dependencies: [
                "VividKernelService"
            ],
            plugins: swiftLintPlugins
        ),
    ]
)
