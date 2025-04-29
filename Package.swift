// swift-tools-version: 6.0

import PackageDescription

var rootPath = #filePath
rootPath.replace("/Package.swift", with: "")

#if DEBUG
    let buildType = "debug"
#else
    // TODO rename this
    let buildType = "debug"
#endif

let cmakeOutputDir = "\(rootPath)/out/build/\(buildType)"

let rustFlags: [String] = [
    "\(rootPath)/Sources/generated/SwiftBridgeCore.swift",
    "\(rootPath)/Sources/generated/logic-kit/logic-kit.swift",
    "\(rootPath)/Sources/generated/build-information/build-information.swift",
    "\(rootPath)/Sources/generated/assets/assets.swift",
    "-import-objc-header", "\(rootPath)/Sources/rust-bridging-header.h",
]

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
                    rustFlags + [
                        // cmake dependencies
                        "-I\(cmakeOutputDir)"
                        //"-I\(rootPath)/Sources/Assets/include",
                    ]),
            ],
            linkerSettings: [
                .linkedLibrary("assets"),
                .linkedLibrary("logic_kit"),
                .linkedLibrary("build_information"),
                .unsafeFlags(
                    rustFlags + [
                        //"-L\(cmakeOutputDir)/Sources/LogicKit",
                        //"-L\(cmakeOutputDir)/Sources/Assets",
                        "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
                        "-Ltarget/\(buildType)",
                    ]),
            ]),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx20
)
