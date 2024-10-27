// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [
      .iOS(.v17),
    ],
    products: [
      .library(name: "RootFeature", targets: ["RootFeature"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.2")
    ],
    targets: [
      .target(
        name: "RootFeature",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
    ]
)
