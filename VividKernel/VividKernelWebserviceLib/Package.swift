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
    name: "VividKernelWebserviceLib",

    // Can run only on this platform.
    // This "requirement" is for SwiftLint and Vapor.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelWebserviceLib",
            targets: ["VividKernelWebserviceLib"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: swiftLintDependency + [

        // Public dependencies.
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.115.0"),

        // Private dependencies.
        .package(path: "../VividKernelServiceImpl"),
        .package(path: "../VividKernelDataAccessService"),
        .package(path: "../VividKernelDataAccessServiceInMemory"),
    ],

    // We have the following targets.
    targets: [

        // Executable main target.
        .target(
            name: "VividKernelWebserviceLib",
            dependencies: [
                "VividKernelServiceImpl",
                "VividKernelDataAccessService",
                .product(name: "Vapor", package: "vapor"),
            ],
            plugins: swiftLintPlugins
        ),
        
        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividKernelWebserviceLibTests",
            dependencies: [
                "VividKernelWebserviceLib",
                "VividKernelDataAccessServiceInMemory",
                .product(name: "VaporTesting", package: "vapor"),
            ],
            plugins: swiftLintPlugins
        ),
    ]
)
