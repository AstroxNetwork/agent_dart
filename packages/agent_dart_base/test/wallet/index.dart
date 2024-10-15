import '../test_utils.dart';
import 'aes.dart' as aes;
import 'pem.dart' as pem;
import 'signer.dart' as signer;

void main() {
  ffiInit();
  aes.main();
  pem.main();
  signer.main();
}
