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
        .package(url: "https://github.com/apple/swift-nio.git", exact: "2.84.0"),

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
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                "VividCommon",
                "VividKernelContract",
                "VividKernelImpl"
            ],
            swiftSettings: swiftSettings,
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")],
        ),

        // Test target
        .testTarget(
            name: "VividKernelWebserviceTests",
            dependencies: [
                .target(name: "VividKernelWebservice"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
