// swift-tools-version: 6.1.2

import PackageDescription

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
    dependencies: [

        // Public dependencies.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1"),
        
        // Private dependencies.
        .package(path: "../VividKernelContract"),
    ],

    // We have the following targets.
    targets: [

        // Main target.
        // SwiftLint is used as plugin when the project is build.
        .target(
            name: "VividKernelDataAccessService",
            dependencies: [
                "VividKernelContract"
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ]
)
