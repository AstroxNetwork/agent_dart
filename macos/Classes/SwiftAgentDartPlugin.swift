import Cocoa
import FlutterMacOS

public class SwiftAgentDartPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // ignore this
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(nil);
  }
  public func dummyMethodToEnforceBundling() {
    // dummy calls to prevent tree shaking
    rust_cstr_free(nil);
    bls_verify("","","");
    bls_init();
  }
}
