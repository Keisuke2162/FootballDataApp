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
          "HomeFeature",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "API",
        dependencies: [
          "Entities",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "Entities",
        dependencies: [
        ]
      ),
      .target(
        name: "Extensions",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "FixtureFeature",
        dependencies: [
          "API",
          "Entities",
          "Extensions",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "HomeFeature",
        dependencies: [
          "API",
          "Entities",
          "Extensions",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "StandingFeature",
        dependencies: [
          "API",
          "Entities",
          "Extensions",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "StatFeature",
        dependencies: [
          "API",
          "Entities",
          "Extensions",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      )
    ]
)
