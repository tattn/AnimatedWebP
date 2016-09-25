Pod::Spec.new do |s|
  s.name = 'AnimatedWebP'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Decode an animated WebP in Swift 3'
  s.homepage = 'https://github.com/tattn/AnimatedWebP'
  s.authors = { 'tattn (Tatsuya TANAKA)' => 'tanakasan2525@gmail.com' }
  s.source = { :git => 'https://github.com/tattn/AnimatedWebP.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'AnimatedWebP/*.swift'
end

