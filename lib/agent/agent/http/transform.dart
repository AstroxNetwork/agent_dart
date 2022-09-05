import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/agent/utils/leb128.dart';
import 'package:cbor/cbor.dart' as cbor;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:typed_data/typed_data.dart';

import 'types.dart';

final _nanoSecondsPerMilliseconds = BigInt.from(1000000);
final _replicaPermittedDriftMilliseconds = BigInt.from(60 * 1000);

class Expiry extends ToCborable {
  Expiry(
    int deltaInMSec,
  ) : _value = (BigInt.from(DateTime.now().millisecondsSinceEpoch) +
                BigInt.from(deltaInMSec) -
                _replicaPermittedDriftMilliseconds) *
            _nanoSecondsPerMilliseconds;

  final BigInt _value;

  BigInt get value => _value;

  Uint8List toHash() {
    return lebEncode(_value);
  }

  @override
  void write(cbor.Encoder encoder) {
    if (kIsWeb) {
      var data = serializeValue(0, 27, _value.toRadixString(16));
      var buf = Uint8Buffer();
      buf.addAll(data.asUint8List());
      encoder.addBuilderOutput(buf);
    } else {
      encoder.writeInt(_value.toInt());
    }
  }
}

HttpAgentRequestTransformFnCall makeNonceTransform([
  NonceFunc nonceFn = makeNonce,
]) {
  return (HttpAgentRequest request) async {
    // Nonce are only useful for async calls, to prevent replay attacks. Other types of
    // calls don't need Nonce so we just skip creating one.
    if (request.endpoint == Endpoint.call) {
      (request as HttpAgentSubmitRequest).body.nonce = nonceFn();
    }
    return request;
  };
}

typedef NonceFunc = Nonce Function();
