#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agent_dart.podspec` to validate before publishing.
#
Pod::Spec.new do |spec|
  spec.name          = 'agent_dart'
  spec.version       = '0.0.1'
  spec.license       = { :file => '../LICENSE' }
  spec.homepage      = 'https://github.com/AstroxNetwork/agent_dart'
  spec.authors       = { 'AstroX Dev' => 'dev@astrox.network' }
  spec.summary       = 'iOS/macOS Flutter bindings for agent_dart'

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  spec.source              = { :path => '.' }
  spec.source_files        = 'Classes/**/*'
  spec.public_header_files = 'Classes/**/*.h'
  spec.vendored_frameworks = "Frameworks/#{framework_name}"

  spec.dependency 'FlutterMacOS'
  spec.platform = :osx, '10.11'
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  spec.swift_version = '5.0'

  spec.ios.deployment_target = '11.0'
  spec.osx.deployment_target = '10.11'

  spec.script_phase = {
    :name => 'Build Rust library',
    # First argument is relative path to the `rust` folder, second is name of rust library
    :script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../../agent_dart_ffi/native/agent_dart agent_dart',
    :execution_position => :before_compile,
    :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
    # Let XCode know that the static library referenced in -force_load below is
    # created by this build step.
    :output_files => ["${BUILT_PRODUCTS_DIR}/libagent_dart.a"],
  }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/libagent_dart.a',
  }
end
