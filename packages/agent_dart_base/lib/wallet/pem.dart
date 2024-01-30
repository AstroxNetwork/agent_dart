import 'dart:io';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asn1.dart';

enum KeyType { ed25519, secp265k1 }

class PemFile {
  const PemFile(this.rawString, this.keyType);

  final String rawString;
  final KeyType keyType;
}

Future<PemFile> getPemFile(String path) async {
  final pem = await File(path).readAsString();
  if (pem.split(CryptoUtils.BEGIN_PRIVATE_KEY).length > 1) {
    return PemFile(
      pem.split(CryptoUtils.BEGIN_PRIVATE_KEY)[1],
      KeyType.ed25519,
    );
  } else if (pem.split(CryptoUtils.BEGIN_EC_PRIVATE_KEY).length > 1) {
    return PemFile(
      pem.split(CryptoUtils.BEGIN_EC_PRIVATE_KEY)[1],
      KeyType.secp265k1,
    );
  }
  throw UnsupportedError('$path does not have a supported PEM type.');
}

Future<Ed25519KeyIdentity> ed25519KeyIdentityFromPem(String pem) async {
  final privateKeyPem = pem
      .replaceAll('-----END PRIVATE KEY-----', '')
      .replaceAll(RegExp(r'\n+'), '')
      .replaceAll(RegExp(r'\s+'), '')
      .trim()
      .replaceAll('r[^0-9a-zA-Z/+]', '');
  final keyBytes = base64Decode(privateKeyPem);
  final ASN1Parser p = ASN1Parser(keyBytes);
  final ASN1Sequence seq = p.nextObject() as ASN1Sequence;
  final ASN1Parser p2 = ASN1Parser(seq.elements?[2].valueBytes);
  final octetStringSeq = p2.nextObject() as ASN1OctetString;
  final res = octetStringSeq.valueBytes!;
  return Ed25519KeyIdentity.generate(res);
}

Future<Secp256k1KeyIdentity> secp256k1KeyIdentityFromPem(String pem) async {
  final pem2 = CryptoUtils.BEGIN_EC_PRIVATE_KEY + pem;
  final key = CryptoUtils.ecPrivateKeyFromPem(pem2).d;
  final prvU8a = key!.toU8a();
  return Secp256k1KeyIdentity.fromSecretKey(prvU8a);
}
