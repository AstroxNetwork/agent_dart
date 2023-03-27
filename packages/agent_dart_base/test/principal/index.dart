import 'principal.dart' as principal;
import 'utils/base32.dart' as base32;
// ignore: library_prefixes
import 'utils/get_crc.dart' as getCrc;

void main() {
  base32.main();
  getCrc.main();
  principal.main();
}
