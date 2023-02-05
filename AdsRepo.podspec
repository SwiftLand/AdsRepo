Pod::Spec.new do |s|
  s.name             = 'AdsRepo'
  s.version          = '0.3.0'
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
  s.requires_arc  = true
  s.static_framework = true
  s.default_subspec = 'Core'
  

 s.subspec 'Core' do |core|
   core.source_files = 'Sources/AdsRepo/Core/**/*'
   
   s.test_spec 'Tests' do |test_spec|
     test_spec.source_files = 'Tests/Core/**/*'
     test_spec.dependency 'Nimble', '10.0.0'
     test_spec.dependency 'Quick', '5.0.1'
   end
 end
 
  s.subspec 'GoogleMobileAds' do |gad|
    
    gad.source_files = 'Sources/AdsRepo/GoogleMobileAds/**/*'
    gad.dependency 'AdsRepo/Core'
    gad.dependency  'Google-Mobile-Ads-SDK'
    
    gad.test_spec 'Tests' do |test_spec|
      test_spec.source_files = ['Tests/GoogleMobileAds/**/*']
      test_spec.dependency 'Nimble', '10.0.0'
      test_spec.dependency 'Quick', '5.0.1'
    end
  end
end
