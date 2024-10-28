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
      .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
      .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "1.0.2"),
      .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.5.4"),
      .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.0"),
      .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.3.0"),
      .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.2.2"),
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.2"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.0"),
      .package(url: "https://github.com/onevcat/Kingfisher", from: "8.1.0"),
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
        name: "Extensions",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
      .target(
        name: "Entities",
        dependencies: [
          "Extensions"
        ]
      ),
      .target(
        name: "API",
        dependencies: [
          "Entities",
          .product(name: "Dependencies", package: "swift-dependencies"),
          .product(name: "DependenciesMacros", package: "swift-dependencies"),
          .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
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
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
          .product(name: "Kingfisher", package: "Kingfisher")
        ]
      ),
      .target(
        name: "HomeFeature",
        dependencies: [
          "API",
          "Entities",
          "Extensions",
          "StandingFeature",
          "StatFeature",
          "FixtureFeature",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
      ),
    ]
)
