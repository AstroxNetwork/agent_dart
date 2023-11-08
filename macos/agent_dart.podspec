release_tag_name = 'agent_dart-v1.0.0' # generated; do not edit

# We cannot distribute the XCFramework alongside the library directly,
# so we have to fetch the correct version here.
framework_name = 'AgentDart.xcframework'
remote_zip_name = "#{framework_name}.zip"
url = "https://github.com/AstroxNetwork/agent_dart/releases/download/#{release_tag_name}/#{remote_zip_name}"
local_zip_name = "#{release_tag_name}.zip"
`
cd Frameworks

if [ ! -f #{local_zip_name} ]
then
  curl -L #{url} -o #{local_zip_name}
fi

if [ -f #{local_zip_name} ]
then
  rm -rf #{framework_name}
  unzip #{local_zip_name}
fi

cd -
`

Pod::Spec.new do |spec|
  spec.name          = 'agent_dart'
  spec.version       = '1.0.0'
  spec.license       = { :file => '../LICENSE' }
  spec.homepage      = 'https://github.com/AstroxNetwork/agent_dart'
  spec.authors       = { 'AstroX Dev' => 'dev@astrox.network' }
  spec.summary       = 'iOS/macOS Flutter bindings for agent_dart'

  spec.source              = { :path => '.' }
  spec.source_files        = 'Classes/**/*'
  spec.public_header_files = 'Classes/**/*.h'
  spec.vendored_frameworks = "Frameworks/#{framework_name}"
  spec.dependency 'FlutterMacOS'

  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  spec.osx.deployment_target = '10.15'
end
