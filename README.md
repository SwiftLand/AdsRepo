![Logo](./AdsRepoBanner.png)

# AdsRepo

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/) [![CI Status](https://img.shields.io/travis/x-oauth-basic/AdsRepo.svg?style=flat)](https://travis-ci.org/x-oauth-basic/AdsRepo) [![Version](https://img.shields.io/cocoapods/v/AdsRepo.svg?style=flat)](https://cocoapods.org/pods/AdsRepo)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange.svg?style=flat)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

**AdsRepo** is an repository for manage,load and show a

## Screenshots

| **Fast load**                                               | **multipale repositories**                                   |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
| ![App Screenshot](./Screenshots/fast-load-screenshot.gif)   | ![App Screenshot](./Screenshots/multi-repo-screenshot.gif)   |
| **Auto refresh**                                            | **Notify expire ads**                                        |
| ![App Screenshot](./Screenshots/auto-update-screenshot.gif) | ![App Screenshot](./Screenshots/notify-expire-sceenshot.png) |

## Features

- Easy to use
- Load ads as fast as possible
- Manage ad reload time
- Manage show number for each ad
- Notify expired ads
- Try handle errors before notify
- All function have Quick Help

## Installation

AdsRepo is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# core only
pod 'AdsRepo'
# with tests
pod 'AdsRepo' , :testspecs => ['Tests']
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate AdsRepo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ali72/AdsRepo"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 
Once you have your Swift package set up, adding AdsRepo as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ali72/AdsRepo.git", .upToNextMajor(from: "Latest_version"))
]
```

### Manually

Alternatively you can copy the `Sources` folder and its files into your project and install the required dependencies.

- [AdMob](https://developers.google.com/admob/ios/quick-start#manual_download)

## Usage/Examples

### Repository

We have three pre-maded repositories.**Native**,**Interstitial** and **Rewarded** all repositories at least require **RepositoryConfig** value to initialize.

**RepositoryConfig** is a struct that contain all reposiotires properies.

```swift
public struct RepositoryConfig{
    
    public let adUnitId:String
    public let size:Int
    public let expireIntervalTime:TimeInterval
    public let showCountThreshold:Int
    
    public init(
        adUnitId:String,//unitId that's google provided
        size:Int,//repository total size
        expireIntervalTime:TimeInterval = 120,//reopo in second
        showCountThreshold:Int = 1//max time can show an ad
    )
}
```

After you create your configuration pass it to your repository object.

```swift
// for InterstitialAds
InterstitialAdRepository(config:/*your RepositoryConfig*/)
// for Rewarded Ads
RewardedAdRepository(config:/*your RepositoryConfig*/)
// for Native Ads
NativeAdRepository(config:/*your RepositoryConfig*/)
```

#### Full-screen

for Present full-screen ad repositories (like Interstitial and Rewarded), you have to call `presentAd` function to show ads to users:

```swift
// for Interstitial repositories
func presentAd(vc: UIViewController,willLoad: ((InterstitialAdWrapper?) -> Void)? = nil) -> Bool
// for Rewarded repositories
func presentAd(vc: UIViewController, willLoad: ((RewardedAdWrapper?) -> Void)? = nil) -> Bool
```

These functions return `true` if can load ads from the repository otherwise return `false`. you can access the ad before the show to the user with `willLoad` closure. you can use `willLoad` to set the delegate for an ad like this :

```swift
anyFullScreenAdsRepo.presentAd(vc: self) {[weak self] ad in
                                          ad?.delegate = self
                                         }
```

**Note**: `willLoad` return ad when finding ad inside repository otherwise return nil. it has different functionality from `adWillPresentFullScreenContent` inside `GADFullScreenContentDelegate`.

#### Native

For native ads, it has a slight difference. Instead of `presentAd` you have `loadAd` function.

```swift
func loadAd(loadFromRepo: @escaping ((NativeAdWrapper?) -> Void)) -> Bool
```

Like `presentAd`, it will return `true` if can load ads from the repository otherwise return `false`. you can access the ad with the `loadFromRepo` closure input.

You can also change **AdLoader** config with this function:

```swift
func adLoaderConfig(adLoaderOptions: [GADAdLoaderOptions], adTypes: [GADAdLoaderAdType]? = nil, rootVC: UIViewController? = nil)## 
```

**Note**: `GADMultipleAdsAdLoaderOptions` will always override with repository size.

#### Common

Both Native and full-screen repositories have a common feature.

```swift
    /// Current repository configuration. See **RepositoryConfig.swift** for more details.
    var config:RepositoryConfig {get}
    
    /// Return `true` if current repository is in loading state
    var isLoading:Bool {get}
    
    /// If `true` repository will load new ads automatically when
    /// requiring otherwise you need to call `fillRepoAds` manually.
    var autoFill:Bool {set get}
    
    /// If `true` repository remove all ads 
    /// (also delegate `removeFromRepository` function for each 
    /// removed ad) and never fill repository again even 
    /// after call `fillRepoAds`,`loadAd` or `presentAd` function.
    /// if `false` and `autofill` is `true`  (default : `true`), It will fill repository with ads
    var isDisable:Bool{set get}
    
    /// Return  repository loaded ad count
    var AdCount:Int{get}
    
    /// Return `true` if the repository contains ads otherwise return `false`
    var hasAd:Bool{get}
    
    /// Return `true` if the repository contains valid ads otherwise return `false`
    var hasValidAd:Bool{get}
    
    /// Return  repository invalid ad count
    var invalidAdCount:Int{get}
    
    /// Return  repository valid ad count
    var validAdCount:Int{get}
    
    /// Return `true` if the repository contains Invalid ads otherwise return `false`
     var hasInvalidAd:Bool{get}
    
    ///  Fill repository with new ads
    ///
    ///- Precondition
    ///    * Repository not disable
    ///    * Repository not fill
    ///    * Repository contain invalid ads
    ///    * Repository not already in loading
    ///
    /// - Returns: `true` if start to fill repository
    ///             otherwise, return `false`
    @discardableResult
    func fillRepoAds()->Bool
    
    
    /// Will remove invalid ads (which confirm `invalidAdCondition`) instantly
    /// - NOTE: After being deleted from the repository, each ad will
    /// delegate `removeFromRepository` function
    func validateRepositoryAds()
```

All repositories have an `invalidAdCondition` closure. you can override it to specific when an ad becomes invalid. by default use `showCount` and `expireIntervalTime` to validate ads in repository.

You can all pass `ErrorHandlerConfig` to configurated error handler policy:

```swift
public struct ErrorHandlerConfig{
    public static let defaultDelayBetweenRetyies:Int = 5
    public static let defaultMaxRetryCount:Int = 20
    
    
    /// Delay between each retry (based on seconds)
    public var delayBetweenRetries = ErrorHandlerConfig.defaultDelayBetweenRetyies
    
    /// The maximum number to retry  before fail
    public var maxRetryCount = ErrorHandlerConfig.defaultMaxRetryCount
}
```

You can also pass `delegate` of 

### AdWrapper



## Running Tests

To run tests, run the following command

```bash
  npm run test
```

## FAQ

#### How **AdsRepo** works?

you create repository with spacific config and ask repositry to load ads and connect it to your views. repositories will do the rests.

#### How many repository can make?

as much as you want. but each ads load inside memory that's mean if you set large size for repository or create too much repository it's may cause recive memory warning. 

#### How handle memory warning?

AdsRepo didn't handle memory warnings right now but you can listen to the memory warning delegate and clear or remove some ads inside repositories.

#### why does not support banner ads?

because you can not save banner ads to show it later and it's against the google policies but I offer you to use native ads like banner ads (see the example for more details). in this way, you can save ads and load them as you like.

## Authors

- [@ali72](https://www.github.com/ali72)

## Contributing

Contributions are always welcome!

For contributing, please download the project and create a new branch and add your codes. after all your job is done please run project tests (and your tests if you add a new one) before pushing your codes to me.

## Roadmap

- Support  **Mediation**
- Support other **Ad networks**

## License

AdsRepo is available under the MIT license. See the LICENSE file for more info.

[MIT](https://choosealicense.com/licenses/mit/)
