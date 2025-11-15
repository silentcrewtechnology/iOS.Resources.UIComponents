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
        .package(url: "https://github.com/silentcrewtechnology/iOS.UITests.AccessibilityIds.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                .product(name: "SnapKit", package: "snapkit"),
                .product(name: "AccessibilityIds", package: "iOS.UITests.AccessibilityIds")
            ]
        )
    ]
)
