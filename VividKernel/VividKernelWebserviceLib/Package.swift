// swift-tools-version: 6.2.0

import PackageDescription

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
    dependencies: [

        // Public dependencies.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.59.1"),
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.115.0"),

        // Private dependencies.
        .package(path: "../VividKernelService"),
        .package(path: "../VividKernelServiceImpl"),
        .package(path: "../VividKernelDataAccessServiceInMemory"),
    ],

    // We have the following targets.
    targets: [

        // Executable main target.
        .target(
            name: "VividKernelWebserviceLib",
            dependencies: [
                "VividKernelService",
                "VividKernelServiceImpl",
                .product(name: "Vapor", package: "vapor"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")],
        ),

        // Test target
        .testTarget(
            name: "VividKernelWebserviceLibTests",
            dependencies: [
                "VividKernelWebserviceLib",
                "VividKernelDataAccessServiceInMemory",
                .product(name: "VaporTesting", package: "vapor"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        )
    ]
)
