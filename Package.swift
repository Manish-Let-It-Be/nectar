// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Nectar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Nectar",
            targets: ["Nectar"]),
    ],
    dependencies: [
        // Remove CountryPicker dependency if it exists
    ],
    targets: [
        .target(
            name: "Nectar",
            dependencies: []),
        .testTarget(
            name: "NectarTests",
            dependencies: ["Nectar"]),
    ]
) 