// swift-tools-version: 6.0

import Foundation
import PackageDescription

func executeCommand(command: String, args: [String]) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = [command]
    task.arguments?.append(contentsOf: args)
    task.launch()
}

let rootPath = "/workspace/"

let rustFFIFlags = [
    // corpus
    "\(rootPath)/Sources/Assets/generated/SwiftBridgeCore.swift",
    "\(rootPath)/Sources/Assets/generated/assets/assets.swift",
    "-import-objc-header", "\(rootPath)/Sources/Assets/include/rust-bridging-header.h",
]

let cmakeOutputDir = "\(rootPath)/out/build/debug-x86-64-unknown-linux-gnu"

executeCommand(command: "cargo", args: ["build"])
executeCommand(
    command: "cmake",
    args: [
        "-S.", "-B\(cmakeOutputDir)", "-GNinja",
        "--preset=debug-x86-64-unknown-linux-gnu",
    ])
executeCommand(
    command: "cmake",
    args: ["--build", "\(cmakeOutputDir)", "--target", "ActKit", "LogicKit"])

#if DEBUG
    let buildType = "debug"
#else
    // TODO rename this
    let buildType = "debug"
#endif

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
                .unsafeFlags(
                    rustFFIFlags + [
                        // cmake dependencies
                        "-I\(cmakeOutputDir)/Sources/ActKit",
                        "-I\(cmakeOutputDir)/Sources/LogicKit",
                        "-I\(cmakeOutputDir)/BuildInformation",
                        "-I\(cmakeOutputDir)",
                        "-L\(cmakeOutputDir)/Sources/ActKit",
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
                        "-L\(rootPath)target/\(buildType)", "-lassets",
                        "-L\(cmakeOutputDir)/Sources/ActKit",
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/swi-prolog-prefix/src/swi-prolog-build/src",
                        "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
                        "-lActKit",
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
