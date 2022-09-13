import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';

class SigningBlockDecoder extends ZipDecoder {
  SigningBlockDecoder(this.file) {
    _init();
  }

  static const blockMagicNumber = 'RPK Sig Block 42';

  late ZipDirectory zipDirectory;
  late InputStream _input;
  int _magicNumberOffset = -1;
  int _signingBlockEndOffset = -1;
  int _signingBlockStartOffset = -1;

  final File file;

  final List<Uint8List> _messages = [];
  final List<Uint8List> _signatures = [];
  final List<Uint8List> _publicKeys = [];
  final List<int> _algoIds = [];

  SigningBlockResultList getResult([bool pubKey = false]) {
    if (_messages.length != _signatures.length) {
      throw RangeError(
        'Message length ${_messages.length} is not equals to '
        'signatures length ${_signatures.length}.',
      );
    }
    if (_signatures.length != _algoIds.length) {
      throw RangeError(
        'Algos length ${_algoIds.length} is not equals to '
        'signatures length ${_signatures.length}.',
      );
    }
    final result = <SigningBlockResult>[];
    for (var i = 0; i < _messages.length; i += 1) {
      result.add(
        SigningBlockResult(
          algoId: _algoIds[i],
          signature: _signatures[i],
          message: _messages[i],
          publicKey: pubKey == true ? _publicKeys[i] : null,
        ),
      );
    }
    return result;
  }

  void _init() {
    _input = InputStream(file.readAsBytesSync());
    getDirectory();
    checkMagicNumber();
  }

  void getDirectory() {
    directory = ZipDirectory.read(_input);
  }

  void checkMagicNumber() {
    if (!_checkMagicNumber()) {
      throw StateError('Magic number is incorrect.');
    }
  }

  void extractSigningBlocks() {
    _signingBlockEndOffset = _magicNumberOffset - 4;
    final blockSize = _getSigningBlockSize();
    _signingBlockStartOffset = _signingBlockEndOffset - blockSize;
    int currentOffset = _signingBlockStartOffset;

    while (currentOffset < _signingBlockEndOffset) {
      _input.offset = currentOffset;
      final subBlockSize = _input.readUint32();
      currentOffset = currentOffset + 4;
      _input.offset = currentOffset;
      currentOffset = currentOffset + 4;
      _input.offset = currentOffset;
      extractSubBlockBody(currentOffset, subBlockSize);
      currentOffset = currentOffset + subBlockSize;
      break;
    }
  }

  void extractSubBlockBody(int start, int end) {
    int current = start;
    _input.offset = current;
    current = current + 4;
    _input.offset = current;
    final messageBlockSize = _input.readUint32();
    current = current + 4;
    while (current < current + messageBlockSize) {
      current = extractMessageBlock(current, messageBlockSize);
      break;
    }
    _input.offset = current;
    final signatureBlockSize = _input.readUint32();
    current = current + 4;
    while (current < current + signatureBlockSize) {
      current = extractSignatureBlock(current, signatureBlockSize);
      break;
    }
    _input.offset = current;
    final publicKeyBlockSize = _input.readUint32();
    current = current + 4;
    while (current < current + publicKeyBlockSize) {
      current = extractPublicKeyBlock(current, publicKeyBlockSize);
      break;
    }
  }

  int extractMessageBlock(int start, int expectedBlockLength) {
    int current = start;
    _input.offset = current;
    final blockLength = _input.readUint32();
    assert(
      blockLength + 4 == expectedBlockLength,
      'Message BlockLength is not correct',
    );
    current = current + 4;
    _input.offset = current;
    final algoId = _input.readUint32();
    _algoIds.add(algoId);
    current = current + 4;
    _input.offset = current;
    final messageLength = _input.readUint32();
    current = current + 4;
    _input.offset = current;
    final messageBytes = _input.readBytes(messageLength);
    _messages.add(messageBytes.toUint8List());
    return current + messageLength;
  }

  int extractSignatureBlock(int start, int expectedBlockLength) {
    int current = start;
    _input.offset = current;
    final blockLength = _input.readUint32();
    assert(
      blockLength + 4 == expectedBlockLength,
      'Signature BlockLength is not correct',
    );
    current = current + 4;
    _input.offset = current;
    current = current + 4;
    _input.offset = current;
    final signatureLength = _input.readUint32();
    current = current + 4;
    _input.offset = current;
    final signatureBytes = _input.readBytes(signatureLength);
    _signatures.add(signatureBytes.toUint8List());
    return current + signatureLength;
  }

  int extractPublicKeyBlock(int start, int expectedBlockLength) {
    int current = start;
    _input.offset = current;
    final publicKeyLength = _input.readUint32();
    assert(
      publicKeyLength + 4 == expectedBlockLength,
      'PublicKey BlockLength is not correct',
    );
    current = current + 4;
    _input.offset = current;
    final publicKeyBytes = _input.readBytes(publicKeyLength);
    _publicKeys.add(publicKeyBytes.toUint8List());
    return current + publicKeyLength;
  }

  bool _checkMagicNumber() {
    _magicNumberOffset = directory.centralDirectoryOffset - 16;
    _input.offset = _magicNumberOffset;
    final signingBlockNumber = _input.readString(size: 16);
    return signingBlockNumber == SigningBlockDecoder.blockMagicNumber;
  }

  int _getSigningBlockSize() {
    _input.offset = _magicNumberOffset - 4;
    return _input.readUint32();
  }
}

class SigningBlockResult {
  const SigningBlockResult({
    required this.message,
    required this.signature,
    required this.algoId,
    this.publicKey,
  });

  final Uint8List message;
  final Uint8List signature;
  final int algoId;
  final Uint8List? publicKey;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'signature': signature,
      'algoId': algoId,
      'publicKey': publicKey,
    }..removeWhere((k, v) => v == null);
  }
}

typedef SigningBlockResultList = List<SigningBlockResult>;
