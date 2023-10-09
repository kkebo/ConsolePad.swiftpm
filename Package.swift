// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription

let package = Package(
    name: "ConsolePad.swiftpm",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0")
    ],
    products: [],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", "1.0.0"..<"2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ConsolePad",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-long-function-bodies=100"], .when(configuration: .debug)),
                .unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=100"], .when(configuration: .debug)),
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                .unsafeFlags(["-Xfrontend", "-enable-actor-data-race-checks"]),
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ExistentialAny"),
            ]
        )
    ]
)

#if canImport(AppleProductTypes)
    import AppleProductTypes

    package.products += [
        .iOSApplication(
            name: "Console Pad",
            targets: ["ConsolePad"],
            bundleIdentifier: "xyz.kebo.ConsolePad",
            teamIdentifier: "X4678G5DL2",
            displayVersion: "1.0",
            bundleVersion: "18",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.orange),
            supportedDeviceFamilies: [
                .pad,
                .phone,
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad])),
            ],
            appCategory: .developerTools,
            additionalInfoPlistContentFilePath: "Info.plist"
        )
    ]
#endif
