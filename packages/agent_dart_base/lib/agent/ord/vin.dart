//             "txid": "a656d5aedfa27d3f756b2ea7696cddbe4ab8036beb190eb9622d28b8a4a06c7f",
//             "vout": 1,
//             "prevout": {
//                 "scriptpubkey": "5120a1ba2ed13f8073a8609da2ecd6d798210fffa369d5cfd082c70be33cef0c4e34",
//                 "scriptpubkey_asm": "OP_PUSHNUM_1 OP_PUSHBYTES_32 a1ba2ed13f8073a8609da2ecd6d798210fffa369d5cfd082c70be33cef0c4e34",
//                 "scriptpubkey_type": "v1_p2tr",
//                 "scriptpubkey_address": "bc1p5xaza5flspe6scya5tkdd4ucyy8llgmf6h8apqk8p03nemcvfc6qcyvqge",
//                 "value": 420961
//             },
//             "scriptsig": "",
//             "scriptsig_asm": "",
//             "witness": [
//                 "4a2f9ab0cd3b023cefaff941dc31a6f6aeeae67c7ae20d0cd830c416ba1e73ca4f2ae025da73853598ddf30369651038c30ad03466d7d1792d758db7f0b82710"
//             ],
//             "is_coinbase": false,
//             "sequence": 4294967295
//         }

import 'package:freezed_annotation/freezed_annotation.dart';
import 'vout.dart';

part 'vin.freezed.dart';
part 'vin.g.dart';

@unfreezed
class Vin with _$Vin {
  factory Vin({
    required String txid,
    required int vout,
    required Vout prevout,
    required String scriptsig,
    required String scriptsig_asm,
    required List<String> witness,
    required bool is_coinbase,
    required int sequence,
  }) = _Vin;

  factory Vin.fromJson(Map<String, dynamic> json) => _$VinFromJson(json);
}
