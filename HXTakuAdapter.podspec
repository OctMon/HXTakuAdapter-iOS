Pod::Spec.new do |s|
  s.name         = 'HXTakuAdapter'
  s.version      = '0.0.1'
  s.summary      = 'HXSDK 适配器, 用于在TopOn聚合SDK请求广告'
  s.homepage     = 'https://github.com/OctMon/HXTakuAdapter.git'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'OctMon' => 'octmon@qq.com' }
  s.source       = { :git => 'https://github.com/OctMon/HXTakuAdapter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.static_framework = true
  s.source_files = 'HXTakuAdapter/Classes/**/*.{h,m}'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'OTHER_LINK_FLAG' => '$(inherited) -ObjC' }
  
  s.dependency 'AnyThinkiOS', '6.4.87'
  s.dependency 'HXSDK', '4.4.1'
  
end
