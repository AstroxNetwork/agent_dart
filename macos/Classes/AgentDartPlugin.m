#import "AgentDartPlugin.h"
#if __has_include(<agent_dart/agent_dart-Swift.h>)
#import <agent_dart/agent_dart-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agent_dart-Swift.h"
#endif

@implementation AgentDartPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAgentDartPlugin registerWithRegistrar:registrar];
}
@end
