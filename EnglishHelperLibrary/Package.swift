// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnglishHelperLibrary",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "EnglishHelperLibrary",
            targets: ["EnglishHelperLibrary"]),
    ],
    dependencies: [
        .package(path: "../WordSearch"),
        .package(path: "../PictureGame"),
        .package(path: "../CommomLibrary"),
        .package(path: "../GrammarBook")
    ],
    targets: [

        .target(
            name: "EnglishHelperLibrary",
            dependencies: [
                .product(name: "WordSearch", package: "WordSearch"),
                .product(name: "PictureGame", package: "PictureGame"),
                .product(name: "CommomLibrary", package: "CommomLibrary"),
                .product(name: "GrammarBook", package: "GrammarBook")
            ]
        ),
        .testTarget(
            name: "EnglishHelperLibraryTests",
            dependencies: ["EnglishHelperLibrary"]),
    ]
)
