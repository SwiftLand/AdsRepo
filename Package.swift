// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
private let packageName = "AdsRepo"

let package = Package(
    name: "AdsRepo",
    platforms: [
           .iOS(.v11)
       ],
    products: [
        .library(
            name: "AdsRepo",
            targets: ["AdsRepo"]),
    ],
    dependencies: [
            .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "9.10.0")
    ],
    targets: [
        .target(
            name: "AdsRepo",
            dependencies: [
                           .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
                       ]),
        .testTarget(
            name: "AdsRepoTests",
            dependencies: ["AdsRepo"]),
    ],
    swiftLanguageVersions: [.v5]
)
