import 'dart:convert';

import 'dart:math';

import 'package:agent_dart/utils/is.dart';

num idlHash(String s) {
  final arr = utf8.encode(s);

  var h = 0;
  for (var c in arr) {
    h = (h * 223 + c) % pow(2, 32).toInt();
  }
  return h;
}

num idlLabelToId(String label) {
  final reg1 = RegExp(r"^_\d+_$");
  final reg2 = RegExp(r"^_0x[0-9a-fA-F]+_$");

  if (reg1.hasMatch(label) || reg2.hasMatch(label)) {
    final lb = label.substring(1, label.length - 1);

    var result = num.tryParse(lb);

    if (result != null && !isBigInt(result) && result >= 0 && result < pow(2, 32)) {
      return result;
    }
  }

  return idlHash(label);
}
