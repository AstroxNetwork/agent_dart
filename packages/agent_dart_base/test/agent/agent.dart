import '../test_utils.dart';
import 'actor.dart' as actor;
import 'cbor.dart' as cbor;
import 'certificate.dart' as certificate;
import 'request_id.dart' as request_id;
import 'utils/bls.dart' as bls;
import 'utils/hash.dart' as hash;
import 'utils/leb128.dart' as leb128;

void main() {
  ffiInit();
  actor.main();
  cbor.main();
  certificate.main();
  request_id.main();
  bls.main();
  hash.main();
  leb128.main();
}
