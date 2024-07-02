import '../test_utils.dart';
import 'delegation.dart' as delegation;
import 'ed25519.dart' as ed25519;
import 'secp256k1.dart' as secp256k1;

void main() {
  ffiInit();
  // matchFFI();
  delegation.main();
  ed25519.main();
  secp256k1.main();
}
