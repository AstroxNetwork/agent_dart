import 'package:agent_dart/agent_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import './agent/agent.dart' as agent;
import './authentication/authentication.dart' as auth;
import './candid/idl.dart' as candid;
import './identity/identity.dart' as identity;
import './principal/index.dart' as principal;

void main() {
  agent.main();
  auth.main();
  candid.main();
  identity.main();
  principal.main();
}
