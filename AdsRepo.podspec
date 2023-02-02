Pod::Spec.new do |s|
  s.name             = 'AdsRepo'
  s.version          = '0.1.0'
  s.summary          = 'Advertise management system'
  s.documentation_url = 'https://github.com/SwiftLand/AdsRepo'

  s.description      = <<-DESC
  AdsRepo is a Swift base library for managing and loading different ad units simultaneously and controlling all of them under repository options and functions. the repository will load ads and keep them fresh base on developer-specific conditions and you only communicate with the repository to get ads.
                       DESC

  s.homepage         = 'https://github.com/SwiftLand/AdsRepo'
  s.screenshots     = 'https://raw.githubusercontent.com/SwiftLand/AdsRepo/master/Screenshots/auto-update-screenshot.gif', 'https://raw.githubusercontent.com/SwiftLand/AdsRepo/master/Screenshots/fast-load-screenshot.gif',
      'https://raw.githubusercontent.com/SwiftLand/AdsRepo/master/Screenshots/notify-expire-sceenshot.png',
      'https://raw.githubusercontent.com/SwiftLand/AdsRepo/master/Screenshots/multi-repo-screenshot.gif'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ali khajehpour' => 'alikhajepur@gmail.com' }
  s.source           = { :git => 'https://github.com/SwiftLand/AdsRepo.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
   
  s.source_files = 'Sources/AdsRepo/**/*'
  

  s.static_framework = true
  s.dependency 'Google-Mobile-Ads-SDK', '~> 9.10.0'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/AdsRepoTests/**/*'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'Quick'
  end
end
