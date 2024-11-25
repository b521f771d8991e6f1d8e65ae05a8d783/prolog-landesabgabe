// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LX",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        //.library(
        //    name: "ActKit",
        //    targets: ["ActKit"])
    ],
     dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.106.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // .target(
        //    name: "LX"),
        //.testTarget(
        //    name: "LXTests"),
        .target(
            name: "ActKit"),
    ]
)
