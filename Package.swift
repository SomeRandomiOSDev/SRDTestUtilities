// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SRDTestUtilities",

    platforms: [
        .iOS("9.0"),
        .macOS("10.10"),
        .tvOS("9.0"),
        .watchOS("2.0")
    ],

    products: [
        .library(name: "SRDTestUtilities", targets: ["SRDTestUtilities", "SRDTestUtilitiesObjC"])
    ],

    dependencies: [
        .package(url: "https://github.com/SomeRandomiOSDev/ReadWriteLock", from: "1.0.0")
    ],

    targets: [
        .target(name: "SRDTestUtilitiesObjC"),
        .target(name: "SRDTestUtilities", dependencies: ["SRDTestUtilitiesObjC", "ReadWriteLock"]),

        .testTarget(name: "SRDTestUtilitiesObjCTests", dependencies: ["SRDTestUtilities", "SRDTestUtilitiesObjC"]),
        .testTarget(name: "SRDTestUtilitiesSwiftTests", dependencies: ["SRDTestUtilities", "SRDTestUtilitiesObjC"])
    ],

    swiftLanguageVersions: [.version("5")]
)
