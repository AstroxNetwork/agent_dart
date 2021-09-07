import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:agent_dart/utils/extension.dart';

class SigningBlockDecoder extends ZipDecoder {
  static const blockMagicNumber = 'RPK Sig Block 42';
  late ZipDirectory zipDirectory;
  late InputStream _input;
  int _magicNumberOffset = -1;
  int _signingBlockendOffset = -1;
  int _signingBlockstartOffset = -1;

  final File file;

  List<Uint8List> _messages = [];
  List<Uint8List> _signatures = [];
  List<Uint8List> _publicKeys = [];
  List<int> _algoIds = [];

  SigningBlockDecoder(this.file) : super() {
    _init();
  }

  SigningBlockResultList getResult([bool pubKey = false]) {
    if (_messages.length != _signatures.length) {
      throw 'Messages Length:${_messages.length}, is not matched with Signatures length: ${_signatures.length}';
    }
    if (_signatures.length != _algoIds.length) {
      throw 'Algos Length:${_algoIds.length}, is not matched with Signatures length: ${_signatures.length}';
    }
    var result = <SigningBlockResult>[];
    for (var i = 0; i < _messages.length; i += 1) {
      result.add(SigningBlockResult(
          algoId: _algoIds[i],
          signature: _signatures[i],
          message: _messages[i],
          publicKey: pubKey == true ? _publicKeys[i] : null));
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
    var check = _checkMagicNumber();
    if (!check) {
      throw 'MagicNumber is not correct';
    }
  }

  void extractSigningBlocks() {
    _signingBlockendOffset = _magicNumberOffset - 4;
    var blockSize = _getSigningBlockSize();
    _signingBlockstartOffset = _signingBlockendOffset - blockSize;
    var currentOffset = _signingBlockstartOffset;

    while (currentOffset < _signingBlockendOffset) {
      _input.offset = currentOffset;
      var subBlockSize = _input.readUint32();
      currentOffset = currentOffset + 4;
      _input.offset = currentOffset;
      var subBlockID = _input.readUint32();
      currentOffset = currentOffset + 4;
      _input.offset = currentOffset;
      var subBlockBody = _input.readBytes(subBlockSize);
      extractSubBlockBody(currentOffset, subBlockSize);
      currentOffset = currentOffset + subBlockSize;
      break;
    }
  }

  void extractSubBlockBody(int start, int end) {
    var current = start;
    _input.offset = current;
    var bodyLength = _input.readUint32();
    // print(bodyLength);

    // messages
    current = current + 4;
    _input.offset = current;
    var messageBlockSize = _input.readUint32();
    // print(messageBlockSize);
    current = current + 4;

    while (current < current + messageBlockSize) {
      current = extractMessageBlock(current, messageBlockSize);
      break;
    }

    _input.offset = current;
    var signatureBlockSize = _input.readUint32();
    // print(signatureBlockSize);
    current = current + 4;

    while (current < current + signatureBlockSize) {
      current = extractSignatureBlock(current, signatureBlockSize);
      break;
    }

    _input.offset = current;

    var publicKeyBlockSize = _input.readUint32();
    // print(publicKeyBlockSize);
    current = current + 4;

    while (current < current + publicKeyBlockSize) {
      current = extractPublicKeyBlock(current, publicKeyBlockSize);
      break;
    }
  }

  int extractMessageBlock(int start, int expectedBlockLength) {
    //   output.writeUint32(8 + message.lengthInBytes);
    // output.writeUint32(algoId);
    // output.writeUint32(message.lengthInBytes);
    // output.writeBytes(message);
    var current = start;
    _input.offset = current;
    var blockLength = _input.readUint32();
    assert(blockLength + 4 == expectedBlockLength, 'Message Blocklength is not correct');
    current = current + 4;
    _input.offset = current;
    var algoId = _input.readUint32();
    _algoIds.add(algoId);
    current = current + 4;
    _input.offset = current;
    var messageLength = _input.readUint32();

    current = current + 4;
    _input.offset = current;

    var messageBytes = _input.readBytes(messageLength);

    _messages.add(messageBytes.toUint8List());

    return current + messageLength;
  }

  int extractSignatureBlock(int start, int expectedBlockLength) {
    //   output.writeUint32(8 + message.lengthInBytes);
    // output.writeUint32(algoId);
    // output.writeUint32(message.lengthInBytes);
    // output.writeBytes(message);
    var current = start;
    _input.offset = current;
    var blockLength = _input.readUint32();
    assert(blockLength + 4 == expectedBlockLength, 'Signature Blocklength is not correct');
    current = current + 4;
    _input.offset = current;
    var algoId = _input.readUint32();
    current = current + 4;
    _input.offset = current;
    var signatureLength = _input.readUint32();

    current = current + 4;
    _input.offset = current;

    var signatureBytes = _input.readBytes(signatureLength);

    _signatures.add(signatureBytes.toUint8List());

    return current + signatureLength;
  }

  int extractPublicKeyBlock(int start, int expectedBlockLength) {
    //   output.writeUint32(8 + message.lengthInBytes);
    // output.writeUint32(algoId);
    // output.writeUint32(message.lengthInBytes);
    // output.writeBytes(message);
    var current = start;
    _input.offset = current;

    var publicKeyLength = _input.readUint32();
    assert(publicKeyLength + 4 == expectedBlockLength, 'PublicKey Blocklength is not correct');

    current = current + 4;
    _input.offset = current;

    var publicKeyBytes = _input.readBytes(publicKeyLength);

    _publicKeys.add(publicKeyBytes.toUint8List());
    // print(publicKeyBytes.toUint8List().toHex());

    return current + publicKeyLength;
  }

  bool _checkMagicNumber() {
    _magicNumberOffset = directory.centralDirectoryOffset - 16;
    _input.offset = _magicNumberOffset;
    var signingBlockNumber = (_input.readString(size: 16));
    return signingBlockNumber == SigningBlockDecoder.blockMagicNumber;
  }

  int _getSigningBlockSize() {
    _input.offset = _magicNumberOffset - 4;
    return _input.readUint32();
  }
}

class SigningBlockResult {
  final Uint8List message;
  final Uint8List signature;
  final int algoId;
  Uint8List? publicKey;
  SigningBlockResult(
      {required this.message, required this.signature, required this.algoId, this.publicKey});
  Map<String, dynamic> toJson() => {
        'message': message,
        'signature': signature,
        'algoId': algoId,
        'publicKey': publicKey
      }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
}

typedef SigningBlockResultList = List<SigningBlockResult>;
