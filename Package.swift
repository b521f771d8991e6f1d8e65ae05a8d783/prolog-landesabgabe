// swift-tools-version: 6.0

import PackageDescription

let rootPath = "/workspace/"

let rustFFIFlags = [
    // corpus
    "\(rootPath)/Sources/Assets/generated/SwiftBridgeCore.swift",
    "\(rootPath)/Sources/Assets/generated/assets/assets.swift",
    "-import-objc-header", "\(rootPath)/Sources/Assets/include/rust-bridging-header.h",
]

#if DEBUG
    let buildType = "debug"
#else
    // TODO rename this
    let buildType = "debug"
#endif

let target = "x86_64-unknown-linux-gnu"
let cmakeOutputDir = "\(rootPath)/out/build/\(buildType)-\(target)"

let package = Package(
    name: "LX",
    products: [
        .executable(
            name: "LX",
            targets: ["LX"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.112.0"),
        .package(url: "https://github.com/vapor-community/Imperial.git", from: "2.0.0-beta.2"),
    ],
    targets: [
        .executableTarget(
            name: "LX",
            dependencies: [
                .product(name: "Vapor", package: "Vapor"),
                .product(name: "ImperialGitHub", package: "imperial"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(
                    rustFFIFlags + [
                        // cmake dependencies
                        "-I\(cmakeOutputDir)/Sources/LogicKit",
                        "-I\(cmakeOutputDir)/BuildInformation",
                        "-I\(cmakeOutputDir)",
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/BuildInformation",
                        "-L\(cmakeOutputDir)",
                        "-F\(rootPath)/Sources/LogicKit/include",
                        "-I\(rootPath)/Sources/LogicKit/include",
                        "-L\(rootPath)/Sources/LogicKit/include",
                    ]),
            ],
            linkerSettings: [
                .unsafeFlags(
                    rustFFIFlags + [
                        // cmake dependencies
                        "-L\(rootPath)target/x86_64-unknown-linux-gnu/\(buildType)", "-lassets",
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/swi-prolog-prefix/src/swi-prolog-build/src",
                        "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
                        "-lLogicKit",
                        "-lswipl_static",
                        "-larchive",
                        "-lncurses",
                        "-lboost_filesystem",
                    ])
            ])
    ],
    cxxLanguageStandard: .cxx20
)
