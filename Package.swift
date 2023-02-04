// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
private let packageName = "AdsRepo"

let package = Package(
    name: "AdsRepo",
    platforms: [
           .iOS(.v12)
       ],
    products: [
        
        .library(
            name: "AdsRepo",
            targets: ["AdsRepo"]),
        
        .library(
            name: "AdsRepo/GoogleMobileAds",
            targets: [ "AdsRepo/GoogleMobileAds"]),
    ],
    dependencies: [
            .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "9.10.0"),
            .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
            .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
    ],
    targets: [
        .target(
            name: "AdsRepo",
            path: "Sources/AdsRepo/Core"),
        
        .target(
            name: "AdsRepo/GoogleMobileAds",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Sources/AdsRepo/GoogleMobileAds"),
        
        .testTarget(
            name: "AdsRepoTests",
            dependencies: ["AdsRepo","Quick","Nimble"],path: "Tests/Core"),
        .testTarget(
            name: "AdsRepo/GoogleMobileAdsTests",
            dependencies: ["AdsRepo","AdsRepo/GoogleMobileAds","Quick","Nimble"],path: "Tests/GoogleMobileAds"),
    ],
    swiftLanguageVersions: [.v5]
)
