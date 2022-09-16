import 'agent/agent.dart' as agent;
import 'authentication/authentication.dart' as auth;
import 'candid/idl.dart' as candid;
import 'identity/identity.dart' as identity;
import 'principal/index.dart' as principal;
import 'utils/utils_test.dart' as utils;
import 'wallet/signer.dart' as signer;
import 'wallet/pem.dart' as pem;

void main() {
  agent.main();
  auth.main();
  candid.main();
  identity.main();
  principal.main();
  utils.main();
  signer.main();
  pem.main();
}
