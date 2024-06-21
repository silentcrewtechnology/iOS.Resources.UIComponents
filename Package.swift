// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "iOS.Resources.UiComponents",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "iOS.Resources.UiComponents",
            targets: [
                "Components"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                .product(name: "SnapKit", package: "snapkit")
            ]
        )
    ]
)
