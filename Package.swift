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
        .package(url: "https://github.com/vapor/vapor", from: "4.114.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "ActKit"
        ),
        .executableTarget(
            name: "LX",
            dependencies: [
                .product(name: "Vapor", package: "Vapor"),
                .product(name: "JWT", package: "jwt"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(
                    [
                        // cmake dependencies
                        "-I\(cmakeOutputDir)",
                        "-I\(rootPath)/Sources/LogicKit/include",
                        "-I\(rootPath)/Sources/Assets/include",
                    ]),
            ],
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-L\(cmakeOutputDir)/Sources/LogicKit",
                        "-L\(cmakeOutputDir)/Sources/Assets",
                        "-lAssets",
                        "-lLogicKit",
                        "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
                        "-larchive",
                    ])
            ]),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx20
)
