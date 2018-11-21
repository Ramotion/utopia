Pod::Spec.new do |s|
  s.name             = 'utopia'
  s.version          = '0.1.0'
  s.summary          = 'Common utilities for Swift projects'
  s.homepage         = 'https://github.com/Ramotion/utopia'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ramotion' => 'igor.k@ramotion.com' }
  s.source           = { :git => 'https://github.com/Ramotion/utopia.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'utopia/Source/**/*'
end
