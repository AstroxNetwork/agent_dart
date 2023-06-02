import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:collection/collection.dart';

import '../../interfaces.dart';

import '../../types.dart';
import '../../varint.dart' as varuint;
import 'dart:typed_data';

TapTree decode(KeyValue keyVal) {
  if (keyVal.key[0] != OutputTypes.TAP_TREE.index || keyVal.key.length != 1) {
    throw Exception(
      'Decode Error: could not decode tapTree with key 0x${keyVal.key.toHex()}',
    );
  }
  var _offset = 0;
  final List<TapLeaf> data = [];
  while (_offset < keyVal.value.length) {
    final depth = keyVal.value[_offset++];
    final leafVersion = keyVal.value[_offset++];
    final scriptLen = varuint.decode(keyVal.value, _offset);
    _offset += varuint.encodingLength(scriptLen);
    data.add(TapLeaf(
      depth: depth,
      leafVersion: leafVersion,
      script: keyVal.value.sublist(_offset, _offset + scriptLen),
    ));
    _offset += scriptLen;
  }
  return TapTree(leaves: data);
}

KeyValue encode(TapTree tree) {
  final key = Uint8List.fromList([OutputTypes.TAP_TREE.index]);

  final _buf = tree.leaves
      .map((tapLeaf) => [
            Uint8List.fromList([tapLeaf.depth, tapLeaf.leafVersion]),
            varuint.encode(tapLeaf.script.length, null, null),
            tapLeaf.script,
          ])
      .toList()
      .flattened
      .toList(); // TODO: should verify
  final bufs = u8aConcat(_buf);
  return KeyValue(
    key: key,
    value: bufs,
  );
}
// export function encode(tree: TapTree): KeyValue {
//   const key = Buffer.from([OutputTypes.TAP_TREE]);
//   const bufs = ([] as Buffer[]).concat(
//     ...tree.leaves.map(tapLeaf => [
//       Buffer.of(tapLeaf.depth, tapLeaf.leafVersion),
//       varuint.encode(tapLeaf.script.length),
//       tapLeaf.script,
//     ]),
//   );
//   return {
//     key,
//     value: Buffer.concat(bufs),
//   };
// }

// const expected = 'Buffer';

bool check(dynamic data) {
  return ((data.leaves is List) &&
      (data as TapTree).leaves.every(
            (tapLeaf) =>
                tapLeaf.depth >= 0 &&
                tapLeaf.depth <= 128 &&
                (tapLeaf.leafVersion & 0xfe) == tapLeaf.leafVersion &&
                tapLeaf.script is Uint8List,
          ));
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.tapTree == null;
}

final tapTreeConverter = TapTreeConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class TapTreeConverter implements BaseConverter<TapTree> {
  @override
  TapTree Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapTree data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapTree> array,
    TapTree item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapTreeConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
