// swift-tools-version: 6.0

import PackageDescription

#if DEBUG
    let buildType = "debug"
#else
    // TODO rename this
    let buildType = "debug"
#endif

let rustBridgingHeader = "Build/FFI/rust-bridging-header.h"

let package = Package(
    name: "LX",
    products: [
        .executable(
            name: "LX",
            targets: ["LX"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.112.0")
    ],
    targets: [
        .executableTarget(
            name: "LX",
            dependencies: [
                .product(name: "Vapor", package: "Vapor")
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags([
                    "generated/SwiftBridgeCore.swift", "generated/LX-rs/LX-rs.swift",
                    "-import-objc-header", rustBridgingHeader,
                ]),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "generated/SwiftBridgeCore.swift",
                    "generated/LX-rs/LX-rs.swift",
                    "-import-objc-header", rustBridgingHeader,
                    "-Ltarget/\(buildType)", "-lcorpus",
                ])
            ])
    ],
    cxxLanguageStandard: .cxx20
)
