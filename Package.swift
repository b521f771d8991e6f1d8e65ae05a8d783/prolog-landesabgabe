// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PrologLandesabgabe",
    products: [
        .library(name: "ActKit", targets: ["ActKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ActKit",
            dependencies: []),
        .testTarget(
            name: "ActKitTests",
            dependencies: ["ActKit"]),
    ]
)
