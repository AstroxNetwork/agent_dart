import Flutter
import UIKit


public class SwiftAgentDartPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // ignore this
    print("dummy_value=\(dummy_method_to_enforce_bundling())");
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(nil);
  }
  public func dummyMethodToEnforceBundling() {
    // dummy calls to prevent tree shaking
    dummy_method_to_enforce_bundling();
  }
}
