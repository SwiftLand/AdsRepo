#
# Be sure to run `pod lib lint AdsRepo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdsRepo'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AdsRepo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/x-oauth-basic/AdsRepo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'x-oauth-basic' => 'alikhajepur@gmail.com' }
  s.source           = { :git => 'https://github.com/x-oauth-basic/AdsRepo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AdsRepo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AdsRepo' => ['AdsRepo/Assets/*.png']
  # }
  s.static_framework = true
  s.frameworks = 'UIKit'
  s.dependency 'Google-Mobile-Ads-SDK'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'AdsRepo/Tests/**/*'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'Quick'
  end
end
