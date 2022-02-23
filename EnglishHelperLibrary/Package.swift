// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnglishHelperLibrary",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EnglishHelperLibrary",
            targets: ["EnglishHelperLibrary"]),
    ],
    dependencies: [
        .package(path: "../WordSearch"),
        .package(path: "../PictureGame"),
        .package(path: "../CommomLibrary"),
        .package(name: "Realm", url: "https://github.com/realm/realm-swift.git", from: "10.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EnglishHelperLibrary",
            dependencies: [
                .product(name: "WordSearch", package: "WordSearch"),
                .product(name: "PictureGame", package: "PictureGame"),
                .product(name: "CommomLibrary", package: "CommomLibrary"),
                .product(name: "Realm", package: "Realm")
            ]
        ),
        .testTarget(
            name: "EnglishHelperLibraryTests",
            dependencies: ["EnglishHelperLibrary"]),
    ]
)
