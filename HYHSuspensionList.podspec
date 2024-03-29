
Pod::Spec.new do |s|
  s.name             = 'HYHSuspensionList'
  s.version          = '0.2.0'
  s.summary          = 'A simple and easy-to-use supension list'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Supension list, like DOUYIN video detail page
                       DESC

  s.homepage         = 'https://github.com/HaoXianSen/HYHSuspensionList'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1335430614@qq.com' => '1335430614@qq.com' }
  s.source           = { :git => 'https://github.com/HaoXianSen/HYHSuspensionList.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HYHSuspensionList/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HYHSuspensionList' => ['HYHSuspensionList/Assets/*.png']
  # }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
