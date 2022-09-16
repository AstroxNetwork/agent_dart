# Run `pod lib lint agent_dart.podspec` to validate before publishing.
Pod::Spec.new do |s|
  s.name             = 'agent_dart'
  s.version          = '1.0.0'
  s.summary          = 'A new flutter plugin project.'
  s.description      = 'An agent library built for Internet Computer.'
  s.homepage         = 'https://astrox.me'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'AstroxNetwork' => 'dev@astrox.network' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes/**/*.h'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.user_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.swift_version = '5.0'
end
