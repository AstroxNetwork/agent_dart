import 'dart:core';

import 'package:collection/collection.dart';

import 'interfaces.dart';
import 'package:agent_dart_base/utils/extension.dart';

import 'parser/fromBuffer.dart';
import 'parser/index.dart';
import 'parser/toBuffer.dart';

PsbtAttributes combine(List<PsbtAttributes> psbts) {
  final self = psbts[0];
  final selfKeyVals = psbtToKeyVals(self);
  final others = psbts.sublist(1);
  if (others.isEmpty) throw Exception('Combine: Nothing to combine');

  final selfTx = getTx(self);
  if (selfTx == null) {
    throw Exception('Combine: Self missing transaction');
  }
  final selfGlobalSet = getKeySet(selfKeyVals.globalMapKeyVals);
  final selfInputSets = selfKeyVals.inputKeyVals.map(getKeySet);
  final selfOutputSets = selfKeyVals.outputKeyVals.map(getKeySet);

  for (final other in others) {
    final otherTx = getTx(other);
    if (otherTx == null || !otherTx.toBuffer().equals(selfTx.toBuffer())) {
      throw Exception(
        'Combine: One of the Psbts does not have the same transaction.',
      );
    }
    final otherKeyVals = psbtToKeyVals(other);

    final otherGlobalSet = getKeySet(otherKeyVals.globalMapKeyVals);
    otherGlobalSet.forEach(
      keyPusher(
        selfGlobalSet,
        selfKeyVals.globalMapKeyVals,
        otherKeyVals.globalMapKeyVals,
      ),
    );

    final otherInputSets = otherKeyVals.inputKeyVals.map(getKeySet);
    otherInputSets.toList().asMap().forEach((idx, inputSet) {
      inputSet.forEach((key) {
        keyPusher(
          selfInputSets.toList()[idx],
          selfKeyVals.inputKeyVals[idx],
          otherKeyVals.inputKeyVals[idx],
        )(key);
      });
    });

    final otherOutputSets = otherKeyVals.outputKeyVals.map(getKeySet);
    otherOutputSets.toList().asMap().forEach((idx, outputSet) {
      outputSet.forEach((key) {
        keyPusher(
          selfOutputSets.toList()[idx],
          selfKeyVals.outputKeyVals[idx],
          otherKeyVals.outputKeyVals[idx],
        )(key);
      });
    });
  }

  final globalKeyVals = selfKeyVals.globalMapKeyVals;
  final inputKeyVals = selfKeyVals.inputKeyVals;
  final outputKeyVals = selfKeyVals.outputKeyVals;

  return psbtFromKeyVals(
      selfTx,
      PsbtFromKeyValsArg(
        globalMapKeyVals: selfKeyVals.globalMapKeyVals,
        inputKeyVals: selfKeyVals.inputKeyVals,
        outputKeyVals: selfKeyVals.outputKeyVals,
      ));
}

typedef KeyPusher = void Function(String key);

KeyPusher keyPusher(
  Set<String> selfSet,
  List<KeyValue> selfKeyVals,
  List<KeyValue> otherKeyVals,
) {
  return (String key) {
    if (selfSet.contains(key)) return;
    final newKv = otherKeyVals.where((kv) => kv.key.toHex() == key).toList()[0];
    selfKeyVals.add(newKv);
    selfSet.add(key);
  };
}

Transaction getTx(PsbtAttributes psbt) {
  return psbt.globalMap.unsignedTx;
}

Set<String> getKeySet(List<KeyValue> keyVals) {
  final set = <String>{};
  keyVals.forEach((keyVal) {
    final hex = keyVal.key.toHex();
    if (set.contains(hex)) {
      throw Exception('Combine: KeyValue Map keys should be unique');
    }
    set.add(hex);
  });
  return set;
}
