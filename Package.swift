// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Convey",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Convey",
            targets: [
                "Convey"
            ]
        ),
    ],
    targets: [
        .target(
            name: "Convey"
        ),
        .testTarget(
            name: "ConveyTests",
            dependencies: [
                "Convey"
            ]
        )
    ]
)
