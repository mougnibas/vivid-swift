// swift-tools-version: 6.2.0

import PackageDescription

let package = Package(

    // Name of the package.
    name: "VividKernelServiceImpl",

    // Can run only on this platform.
    // This "requirement" is actually only for SwiftLint.
    platforms: [
        .macOS(.v15)
    ],

    // This is a library package.
    products: [
        .library(
            name: "VividKernelServiceImpl",
            targets: ["VividKernelServiceImpl"]
        )
    ],

    // This package declare this dependencies (package level).
    dependencies: [

        // Public dependencies.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1"),

        // Private dependencies.
        .package(path: "../VividKernelService"),
        .package(path: "../VividKernelDataAccessService"),
        .package(path: "../VividKernelDataAccessServiceInMemory"),
    ],

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelServiceImpl",
            dependencies: [
                "VividKernelService",
                "VividKernelDataAccessService"
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),

        // Test target, with only one dependency : The main package.
        // SwiftLint is used as plugin when the project is tested.
        .testTarget(
            name: "VividKernelServiceImplTests",
            dependencies: [
                "VividKernelServiceImpl",
                "VividKernelDataAccessServiceInMemory",
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ]
)
