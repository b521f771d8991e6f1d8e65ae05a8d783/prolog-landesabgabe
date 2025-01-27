// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LX",
    products: [
        .executable(
            name: "LX",
            targets: ["LX"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.106.4")
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
                    "-import-objc-header", "bridging-header.h",
                ]),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "generated/SwiftBridgeCore.swift", "generated/LX-rs/LX-rs.swift",
                    "-import-objc-header", "bridging-header.h", "-Ltarget/debug", "-lcorpus",
                ])
            ])
    ],
    cxxLanguageStandard: .cxx20
)
