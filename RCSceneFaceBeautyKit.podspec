#
# Be sure to run `pod lib lint RCSceneFaceBeautyKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCSceneFaceBeautyKit'
  s.version          = '0.0.1.1'
  s.summary          = 'RCSceneFaceBeautyKit of RongCloud Scene.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
			RongCloud RCSceneFaceBeautyKit SDK for iOS.
                       DESC

  s.homepage         = 'https://github.com/rongcloud-community'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license      = { :type => "Copyright", :text => "Copyright 2022 RongCloud" }
  s.author           = { '彭蕾' => 'penglei1@rongcloud.cn' }
  s.source           = { :git => 'https://github.com/rongcloud-community/RCSceneFaceBeautyKit.git', :tag => s.version.to_s }

  s.social_media_url = 'https://www.rongcloud.cn/devcenter'

  s.ios.deployment_target = '11.0'

  s.source_files = 'RCSceneFaceBeautyKit/Classes/**/*'
  
   s.resource_bundles = {
     'RCSceneFaceBeautyKit' => ['RCSceneFaceBeautyKit/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RongFUFaceBeautifier', '~> 5.2.5'
  s.dependency 'RCSceneBaseKit'
  s.dependency 'YYModel'
  s.dependency 'Masonry'
  
  s.prefix_header_file = 'RCSceneFaceBeautyKit/Classes/Common/RCSBeautyPrefixHeader.pch'
  
end
