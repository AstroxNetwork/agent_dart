import '../test_utils.dart';
import 'principal.dart' as principal;
import 'utils/base32.dart' as base32;
import 'utils/get_crc.dart' as get_crc;

void main() {
  ffiInit();
  principal.main();
  base32.main();
  get_crc.main();
}
