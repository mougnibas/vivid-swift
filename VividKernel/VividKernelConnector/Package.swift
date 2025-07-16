// swift-tools-version: 6.1.2

import PackageDescription

let package = Package(

    // Name of the package.
    name: "VividKernelConnector",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelConnector",
            targets: ["VividKernelConnector"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: [

        // Public dependencies.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1"),
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.115.0"),

        // Private dependencies.
        .package(path: "../VividKernelService"),
        .package(path: "../VividKernelImpl"),
        .package(path: "../VividKernelWebserviceLib"),
    ],

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelConnector",
            dependencies: [
                "VividKernelService",
                "VividKernelImpl",
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),

        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividKernelConnectorTests",
            dependencies: [
                "VividKernelConnector",
                "VividKernelWebserviceLib",
                .product(name: "Vapor", package: "vapor"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        )
    ]
)
