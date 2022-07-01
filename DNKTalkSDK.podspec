

Pod::Spec.new do |s|
  s.name             = 'DNKTalkSDK'
  s.version          = '1.0.0'
  s.summary          = 'DNKTalkSDK对讲库'
  s.homepage         = 'https://github.com/dnakeyun/dnake-specs'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cqcool' => 'cqcool@icloud' }
  s.source           = { :git => 'https://github.com/dnakeyun/DNKTalkSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.vendored_frameworks = [
   'DNKTalkSDK/DNKTalkSDK.framework', 
  ]
  s.requires_arc = true
end
