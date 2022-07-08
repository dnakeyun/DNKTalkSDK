

Pod::Spec.new do |s|
  s.name             = 'DNKTalkSDK'
  s.version          = '1.0.1'
  s.summary          = 'DNKTalkSDK对讲库'
  s.homepage         = 'https://github.com/dnakeyun/dnake-specs'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cqcool' => 'cqcool@icloud' }
  s.source           = { :git => 'https://github.com/dnakeyun/DNKTalkSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.pod_target_xcconfig = {
        'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
