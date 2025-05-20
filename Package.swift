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

let cmakeSwiftFlags = ["-I\(cmakeOutputDir)"]
let cmakeLinkerFlags = [
    "-L\(cmakeOutputDir)/vcpkg_installed/x64-linux/lib",
    "-Ltarget/\(buildType)",
]

let rustFlags: [String] = [
    "\(rootPath)/Sources/generated/SwiftBridgeCore.swift",
    "\(rootPath)/Sources/generated/prolog-vm/prolog-vm.swift",
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
        .testTarget(name: "ActKitTests", dependencies: ["ActKit"]),
        .executableTarget(
            name: "LX",
            dependencies: [
                .product(name: "Vapor", package: "Vapor"),
                .product(name: "JWT", package: "jwt"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx),
                .unsafeFlags(rustFlags + cmakeSwiftFlags),
            ],
            linkerSettings: [
                .linkedLibrary("assets"),
                .linkedLibrary("prolog_vm"),
                .linkedLibrary("build_information"),
                .unsafeFlags(rustFlags + cmakeLinkerFlags),
            ]),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx20
)
