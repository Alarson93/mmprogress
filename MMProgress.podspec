#
# Be sure to run `pod lib lint MMProgress.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MMProgress"
  s.version          = "1.2.13"
  s.summary          = "MMProgress is a progress hud that offers a variety of UI features."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        "MMProgress is a flexible progress hud. It was built in inspiration from KVNProgress and SVProgressHUD. You can pass in custom animations, provide a background tint, choose whether or not you want full screen, and much more. My goal with this is to create an extremely flexible, beautiful, and easy to use hud."
                       DESC

  s.homepage         = "https://github.com/Alarson93/mmprogress"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alex Larson" => "alarson@myriadmobile.com" }
  s.source           = { :git => "https://github.com/Alarson93/mmprogress", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MMProgress' => ['Pod/Classes/**/*.{xib,png,jpeg,jpg}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SpinKit'
end
