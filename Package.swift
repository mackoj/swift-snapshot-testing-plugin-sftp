// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-snapshot-testing-plugin-sftp",
  
  // TODO: update this with more tested platforms
  platforms: [
    .macOS(.v12),
    .iOS(.v14)
  ],
  
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "SFTPFileTransport",
      targets: ["SFTPFileTransport"]
    ),
  ],
  
  dependencies: [
    .package(url: "https://github.com/orlandos-nl/Citadel.git", from: "0.8.0"),
    .package(path: "/Users/jeffreymacko/Developer/swift-snapshot-testing"),
    //    .package(url: "https://github.com/mackoj/swift-snapshot-testing.git", revision: "b899f13"),
  ],
  
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "SFTPFileTransport",
      dependencies: [
        .product(name: "FileSerializationPlugin", package: "swift-snapshot-testing"),
        .product(name: "Citadel", package: "Citadel"),
      ]
    ),
    .testTarget(
      name: "SFTPFileTransportTests",
      dependencies: ["SFTPFileTransport"]
    ),
  ]
)
