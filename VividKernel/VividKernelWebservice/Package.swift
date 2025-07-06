// swift-tools-version: 6.1.0

import PackageDescription

let package = Package(

    // Name of the package.
    name: "VividKernelWebservice",

    // Can run only on this platform.
    // This "requirement" is for SwiftLint and Vapor.
    platforms: [
       .macOS(.v15)
    ],

    // This package declare this dependencies (package level).
    dependencies: [

        // Public dependencies.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1"),
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.115.0"),

        // Private dependencies.
        .package(path: "../../VividCommon"),
        .package(path: "../VividKernelContract"),
        .package(path: "../VividKernelImpl"),
    ],

    // We have the following targets.
    targets: [

        // Executable main target.
        .executableTarget(
            name: "VividKernelWebservice",
            dependencies: [
                "VividCommon",
                "VividKernelContract",
                "VividKernelImpl",
                .product(name: "Vapor", package: "vapor"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")],
        ),

        // Test target
        .testTarget(
            name: "VividKernelWebserviceTests",
            dependencies: [
                "VividKernelWebservice",
                .product(name: "VaporTesting", package: "vapor"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        )
    ]
)
