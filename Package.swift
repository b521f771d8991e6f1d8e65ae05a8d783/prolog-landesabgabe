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
let generatedPath = "\(rootPath)/Sources/Corpus/generated/"
let rustBridgingHeader = "\(rootPath)Sources/Corpus/include/rust-bridging-header.h"
let cmakeOutputDir = "\(rootPath)/out/build/debug-x86-64-unknown-linux-gnu"

executeCommand(command: "cargo", args: ["build"])
executeCommand(
    command: "cmake",
    args: [
        "-S.", "-Bout/build/debug-x86-64-unknown-linux-gnu", "-GNinja",
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
                .unsafeFlags([
                    "\(generatedPath)SwiftBridgeCore.swift",
                    "\(generatedPath)corpus/corpus.swift",
                    "-import-objc-header", rustBridgingHeader,
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
                .unsafeFlags([
                    "\(generatedPath)SwiftBridgeCore.swift",
                    "\(generatedPath)corpus/corpus.swift",
                    "-import-objc-header", rustBridgingHeader,
                    "-L\(rootPath)target/\(buildType)", "-lcorpus",
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
