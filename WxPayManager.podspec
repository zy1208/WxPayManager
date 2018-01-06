Pod::Spec.new do |s|
s.name = 'WxPayManager'
s.version = '1.0.0'
s.summary = 'zhe shi yi ge ce shi a'
s.homepage = 'https://github.com/zy1208/WxPayManager'
s.license = 'MIT'
s.platform = :ios
s.author = {'zy1208' => 'zy1208i@126.com'}
s.ios.deployment_target = '9.0'
s.source = {:git => 'https://github.com/zy1208/WxPayManager.git',:tag => s.version}
s.source_files = 'WxPayManager/*.{h,m}','WxPayManager/Wx/*.{h}'
s.requires_arc = true
s.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security', 'CoreTelephony'
s.ios.library = 'c++','sqlite3.0','z'
s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
s.vendored_libraries = 'WxPayManager/Wx/*.a'
end
