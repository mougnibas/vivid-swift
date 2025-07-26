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
    name: "VividKernelServiceConnector",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelServiceConnector",
            targets: ["VividKernelServiceConnector"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: swiftLintDependency + [

        // Public dependencies.
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.115.0"),

        // Private dependencies.
        .package(path: "../VividKernelService"),
        .package(path: "../VividKernelWebserviceLibInMemory"),
        .package(path: "../VividKernelWebserviceLibFluent"),
    ],

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelServiceConnector",
            dependencies: [
                "VividKernelService",
            ],
            plugins: swiftLintPlugins
        ),

        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividKernelServiceConnectorTests",
            dependencies: [
                "VividKernelServiceConnector",
                "VividKernelWebserviceLibInMemory",
                "VividKernelWebserviceLibFluent",
                .product(name: "Vapor", package: "vapor"),
            ],
            plugins: swiftLintPlugins
        )
    ]
)
