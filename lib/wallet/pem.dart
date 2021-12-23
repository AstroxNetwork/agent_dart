import 'dart:io';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asn1/object_identifiers.dart';

enum KeyType { ED25519, SECP256k1 }

class PemFile {
  final String rawString;
  final KeyType keyType;
  PemFile(this.rawString, this.keyType);
}

Future<PemFile> getPemFile(String path) async {
  var pem = await File(path).readAsString();
  if (pem.split(CryptoUtils.BEGIN_PRIVATE_KEY).length > 1) {
    return PemFile(
        pem.split(CryptoUtils.BEGIN_PRIVATE_KEY)[1], KeyType.ED25519);
  } else if (pem.split(CryptoUtils.BEGIN_EC_PRIVATE_KEY).length > 1) {
    return PemFile(
        pem.split(CryptoUtils.BEGIN_EC_PRIVATE_KEY)[1], KeyType.SECP256k1);
  }
  throw 'Cannot Read Pem';
}

Future<Ed25519KeyIdentity> ed25519KeyIdentityFromPem(String pem) async {
  try {
    // var pemStart = '-----BEGIN PRIVATE KEY-----';
    var privateKeyPem = pem
        .replaceAll("-----END PRIVATE KEY-----", "")
        .replaceAll(RegExp(r"\n+"), "")
        .replaceAll(RegExp(r"\s+"), "")
        .trim()
        .replaceAll('r[^0-9a-zA-Z/+]', '');
    var keyBytes = base64Decode(privateKeyPem);
    final ASN1Parser p = ASN1Parser(keyBytes);
    final ASN1Sequence seq = p.nextObject() as ASN1Sequence;
    final ASN1Parser p2 = ASN1Parser(seq.elements?[2].valueBytes);
    var octetStringSeq = p2.nextObject() as ASN1OctetString;
    var res = octetStringSeq.valueBytes!;
    return Ed25519KeyIdentity.generate(res);
  } catch (e) {
    rethrow;
  }
}

Future<Secp256k1KeyIdentity> secp256k1KeyIdentityFromPem(String pem) async {
  try {
    // var pem = await File(path).readAsString();
    // var pemStart = '-----BEGIN EC PRIVATE KEY-----';
    // var privateKeyPem = pem.split(pemStart)[1];
    var pem2 = CryptoUtils.BEGIN_EC_PRIVATE_KEY + pem;
    var key = CryptoUtils.ecPrivateKeyFromPem(pem2).d;
    var prvU8a = key!.toU8a();
    return Secp256k1KeyIdentity.fromSecretKey(prvU8a);
  } catch (e) {
    rethrow;
  }
}
