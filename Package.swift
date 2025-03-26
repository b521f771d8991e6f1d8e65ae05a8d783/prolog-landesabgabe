// swift-tools-version: 6.0

import PackageDescription

let rootPath = "/workspace/"

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
        .package(url: "https://github.com/vapor/vapor", from: "4.112.0")
    ],
    targets: [
        .target(
            name: "ActKit"
        ),
        .executableTarget(
            name: "LX",
            dependencies: [
                .product(name: "Vapor", package: "Vapor")
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(
                    [
                        // cmake dependencies
                        "-I\(cmakeOutputDir)/Sources/LogicKit",
                        "-I\(cmakeOutputDir)/BuildInformation",
                        "-I\(cmakeOutputDir)/Sources/Assets",
                        "-I\(cmakeOutputDir)",
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/BuildInformation",
                        "-L\(cmakeOutputDir)/Sources/Assets",
                        "-L\(cmakeOutputDir)",
                        "-F\(rootPath)/Sources/LogicKit/include",
                        "-I\(rootPath)/Sources/LogicKit/include",
                        "-L\(rootPath)/Sources/LogicKit/include",
                        "-F\(rootPath)/Sources/Assets/Include",
                        "-I\(rootPath)/Sources/Assets/Include",
                        "-L\(rootPath)/Sources/Assets/Include",
                    ]),
            ],
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/Sources/Assets",
                        "-lAssets",
                        "-lLogicKit",
                        "-L\(cmakeOutputDir)/swi-prolog-prefix/src/swi-prolog-build/src",
                        "-lswipl_static",
                        "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
                        "-larchive",
                        "-lncurses",
                        "-lboost_filesystem",
                    ])
            ]),
    ],
    cxxLanguageStandard: .cxx20
)
