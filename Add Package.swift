// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GameTranslator",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GameTranslatorCore",
            targets: ["GameTranslatorCore"]
        ),
        .executable(
            name: "GameTranslatorApp",
            targets: ["GameTranslatorApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "GameTranslatorCore",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .executableTarget(
            name: "GameTranslatorApp",
            dependencies: ["GameTranslatorCore"]
        ),
        .testTarget(
            name: "GameTranslatorTests",
            dependencies: ["GameTranslatorCore"]
        )
    ]
)
