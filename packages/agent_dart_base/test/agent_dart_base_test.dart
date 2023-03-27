import 'package:agent_dart_base/src/ffi/io.dart';

import 'agent/agent.dart' as agent;
import 'authentication/authentication.dart' as auth;
import 'candid/idl.dart' as candid;
import 'identity/identity.dart' as identity;
import 'principal/index.dart' as principal;
import 'test_utils.dart';
import 'utils/utils_test.dart' as utils;
import 'wallet/pem.dart' as pem;
import 'wallet/signer.dart' as signer;
import 'dart:io' as io;
import 'dart:ffi';

void main() async {
  matchFFI();
  agent.main();
  auth.main();
  candid.main();
  identity.main();
  principal.main();
  utils.main();
  signer.main();
  pem.main();
}
