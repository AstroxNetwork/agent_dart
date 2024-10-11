import '../test_utils.dart';
import 'delegation.dart' as delegation;
import 'ed25519.dart' as ed25519;
import 'p256.dart' as p256;
import 'schnorr.dart' as schnorr;
import 'secp256k1.dart' as secp256k1;

void main() {
  ffiInit();
  delegation.main();
  ed25519.main();
  p256.main();
  schnorr.main();
  secp256k1.main();
}
