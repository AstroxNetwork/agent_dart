import 'dart:typed_data';

import 'package:agent_dart/agent/agent.dart';
import 'package:archive/archive_io.dart';

class SigningBlock {
  final List<Uint8List> messages;
  final List<Uint8List> signatures;
  final List<PublicKey> publicKeys;

  late List<MessageBlock> messageBlocks;
  late List<SignatureBlock> signatureBlocks;
  late List<PublicKeyBlock> publicKeyBlocks;

  late int blocksCount;
  int algoId;
  SigningBlock.create(
      {required this.messages,
      required this.signatures,
      required this.publicKeys,
      this.algoId = 0x0201}) {
    messageBlocks = <MessageBlock>[]..addAll(messages.map((e) => MessageBlock(e, algoId)));
    signatureBlocks = <SignatureBlock>[]..addAll(signatures.map((e) => SignatureBlock(e, algoId)));
    publicKeyBlocks = <PublicKeyBlock>[]..addAll(publicKeys.map((e) => PublicKeyBlock(e)));
  }

  int messageBlocksSize() {
    var size = 0;
    for (var block in messageBlocks) {
      size += block.size;
    }
    return size;
  }

  int signatureBlocksSize() {
    var size = 0;
    for (var block in signatureBlocks) {
      size += block.size;
    }
    return size;
  }

  int publicKeyBlocksSize() {
    var size = 0;
    for (var block in publicKeyBlocks) {
      size += block.size;
    }
    return size;
  }

  int getSize() {
    return 4 + messageBlocksSize() + 4 + signatureBlocksSize() + 4 + publicKeyBlocksSize();
  }

  void write(OutputStreamBase output) {
    output.writeUint32(getSize()); // message + signature + public length
    // size of message
    output.writeUint32(messageBlocksSize());
    // content of message
    for (var msgBlock in messageBlocks) {
      msgBlock.write(output);
    }

    // size of sigtnaure
    output.writeUint32(signatureBlocksSize());
    // content of signature
    for (var sigBlock in signatureBlocks) {
      sigBlock.write(output);
    }

    // size of publicKey
    output.writeUint32(publicKeyBlocksSize());
    // content of publicKey
    for (var pubBlock in publicKeyBlocks) {
      pubBlock.write(output);
    }
  }
}

class MessageBlock {
  final Uint8List message;
  final int algoId;
  int get size => 12 + message.lengthInBytes;
  MessageBlock(this.message, this.algoId);
  void write(OutputStreamBase output) {
    output.writeUint32(8 + message.lengthInBytes);
    output.writeUint32(algoId);
    output.writeUint32(message.lengthInBytes);
    output.writeBytes(message);
  }
}

class SignatureBlock {
  final Uint8List signature;
  final int algoId;
  int get size => 12 + signature.lengthInBytes;
  SignatureBlock(this.signature, this.algoId);
  void write(OutputStreamBase output) {
    output.writeUint32(8 + signature.lengthInBytes);
    output.writeUint32(algoId);
    output.writeUint32(signature.lengthInBytes);
    output.writeBytes(signature);
  }
}

class PublicKeyBlock {
  final PublicKey publicKey;
  int get size => 4 + publicKey.toDer().lengthInBytes;
  PublicKeyBlock(this.publicKey);
  void write(OutputStreamBase output) {
    var derPubkey = publicKey.toDer();
    output.writeUint32(derPubkey.lengthInBytes);
    output.writeBytes(derPubkey);
  }
}
