Pod::Spec.new do |s|
  s.name = 'AnimatedWebP'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Decode an animated WebP in Swift 3'
  s.homepage = 'https://github.com/tattn/AnimatedWebP'
  s.authors = { 'tattn (Tatsuya TANAKA)' => 'tanakasan2525@gmail.com' }
  s.source = { :git => 'https://github.com/tattn/AnimatedWebP.git', :tag => "v#{s.version}" }
  s.platform = :ios, '8.0'
  s.requires_arc = true 

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.11'
  # s.tvos.deployment_target = '9.0'
  # s.watchos.deployment_target = '2.0'

  s.ios.frameworks = 'UIKit'
  s.ios.vendored_frameworks = 'Frameworks/WebP/WebP.framework'
  s.ios.preserve_paths = 'Frameworks/WebP/WebP.framework'

  s.source_files = ['AnimatedWebP/*.swift', 'Frameworks/WebP/WebP.framework/Headers/*.{h}']
  s.public_header_files = 'Frameworks/WebP/WebP.framework/Headers/*.{h}'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end

