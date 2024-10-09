import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pointycastle/asn1/object_identifiers.dart';
import 'package:pointycastle/pointycastle.dart';

import '../identity/ed25519.dart';
import '../identity/secp256k1.dart';
import '../utils/extension.dart';

const String _beginECPrivateKey = '-----BEGIN EC PRIVATE KEY-----';
const String _beginPrivateKey = '-----BEGIN PRIVATE KEY-----';

enum KeyType { ed25519, secp265k1 }

class PemFile {
  const PemFile(this.rawString, this.keyType);

  final String rawString;
  final KeyType keyType;
}

Future<PemFile> getPemFile(String path) async {
  final pem = await File(path).readAsString();
  if (pem.split(_beginPrivateKey).length > 1) {
    return PemFile(
      pem.split(_beginPrivateKey)[1],
      KeyType.ed25519,
    );
  } else if (pem.split(_beginECPrivateKey).length > 1) {
    return PemFile(
      pem.split(_beginECPrivateKey)[1],
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
  final pem2 = _beginECPrivateKey + pem;
  final key = _ecPrivateKeyFromPem(pem2).d;
  final prvU8a = key!.toU8a();
  return Secp256k1KeyIdentity.fromSecretKey(prvU8a);
}

ECPrivateKey _ecPrivateKeyFromPem(String pem) {
  if (pem.isEmpty) {
    throw ArgumentError('Argument must not be null.');
  }
  final bytes = _getBytesFromPEMString(pem);
  return _ecPrivateKeyFromDerBytes(
    bytes,
    pkcs8: pem.startsWith(_beginPrivateKey),
  );
}

ECPrivateKey _ecPrivateKeyFromDerBytes(Uint8List bytes, {bool pkcs8 = false}) {
  var asn1Parser = ASN1Parser(bytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  String curveName = '';
  Uint8List x;
  if (pkcs8) {
    // Parse the PKCS8 format
    final innerSeq = topLevelSeq.elements!.elementAt(1) as ASN1Sequence;
    final b2 = innerSeq.elements!.elementAt(1) as ASN1ObjectIdentifier;
    final b2Data = b2.objectIdentifierAsString;
    final b2Curvedata = ObjectIdentifiers.getIdentifierByIdentifier(b2Data);
    if (b2Curvedata != null) {
      curveName = b2Curvedata['readableName'];
    }

    final octetString = topLevelSeq.elements!.elementAt(2) as ASN1OctetString;
    asn1Parser = ASN1Parser(octetString.valueBytes);
    final octetStringSeq = asn1Parser.nextObject() as ASN1Sequence;
    final octetStringKeyData =
        octetStringSeq.elements!.elementAt(1) as ASN1OctetString;

    x = octetStringKeyData.valueBytes!;
  } else {
    // Parse the SEC1 format
    final privateKeyAsOctetString =
        topLevelSeq.elements!.elementAt(1) as ASN1OctetString;
    final choice = topLevelSeq.elements!.elementAt(2);
    final s = ASN1Sequence();
    final parser = ASN1Parser(choice.valueBytes);
    while (parser.hasNext()) {
      s.add(parser.nextObject());
    }
    final curveNameOi = s.elements!.elementAt(0) as ASN1ObjectIdentifier;
    final data = ObjectIdentifiers.getIdentifierByIdentifier(
      curveNameOi.objectIdentifierAsString,
    );
    if (data != null) {
      curveName = data['readableName'];
    }

    x = privateKeyAsOctetString.valueBytes!;
  }

  BigInt osp2i = BigInt.from(0);
  for (final byte in x) {
    osp2i = osp2i << 8;
    osp2i |= BigInt.from(byte);
  }

  return ECPrivateKey(osp2i, ECDomainParameters(curveName));
}

Uint8List _getBytesFromPEMString(String pem, {bool checkHeader = true}) {
  final lines = LineSplitter.split(pem)
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  final String base64;
  if (checkHeader) {
    if (lines.length < 2 ||
        !lines.first.startsWith('-----BEGIN') ||
        !lines.last.startsWith('-----END')) {
      throw ArgumentError(
        'The given string does not have the correct '
        'begin/end markers expected in a PEM file.',
      );
    }
    base64 = lines.sublist(1, lines.length - 1).join();
  } else {
    base64 = lines.join();
  }
  return Uint8List.fromList(base64Decode(base64));
}
