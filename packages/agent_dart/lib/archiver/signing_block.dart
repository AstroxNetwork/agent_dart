import 'dart:typed_data';

import 'package:agent_dart/agent/agent.dart';
import 'package:archive/archive_io.dart';

class SigningBlock {
  SigningBlock.create({
    required this.messages,
    required this.signatures,
    required this.publicKeys,
    this.algoId = 0x0201,
  })  : messageBlocks = messages.map((e) => MessageBlock(e, algoId)).toList(),
        signatureBlocks =
            signatures.map((e) => SignatureBlock(e, algoId)).toList(),
        publicKeyBlocks = publicKeys.map((e) => PublicKeyBlock(e)).toList();

  final List<Uint8List> messages;
  final List<Uint8List> signatures;
  final List<PublicKey> publicKeys;
  final int algoId;
  final List<MessageBlock> messageBlocks;
  final List<SignatureBlock> signatureBlocks;
  final List<PublicKeyBlock> publicKeyBlocks;

  int messageBlocksSize() => messageBlocks.fold(0, (p, e) => p += e.size);

  int signatureBlocksSize() => signatureBlocks.fold(0, (p, e) => p += e.size);

  int publicKeyBlocksSize() => publicKeyBlocks.fold(0, (p, e) => p += e.size);

  int getSize() {
    return 4 +
        messageBlocksSize() +
        4 +
        signatureBlocksSize() +
        4 +
        publicKeyBlocksSize();
  }

  void write(OutputStreamBase output) {
    output.writeUint32(getSize()); // message + signature + public length
    // size of message
    output.writeUint32(messageBlocksSize());
    // content of message
    for (final msgBlock in messageBlocks) {
      msgBlock.write(output);
    }

    // size of signature
    output.writeUint32(signatureBlocksSize());
    // content of signature
    for (final sigBlock in signatureBlocks) {
      sigBlock.write(output);
    }

    // size of publicKey
    output.writeUint32(publicKeyBlocksSize());
    // content of publicKey
    for (final pubBlock in publicKeyBlocks) {
      pubBlock.write(output);
    }
  }
}

class MessageBlock {
  const MessageBlock(this.message, this.algoId);

  final Uint8List message;
  final int algoId;

  int get size => 12 + message.lengthInBytes;

  void write(OutputStreamBase output) {
    output.writeUint32(8 + message.lengthInBytes);
    output.writeUint32(algoId);
    output.writeUint32(message.lengthInBytes);
    output.writeBytes(message);
  }
}

class SignatureBlock {
  const SignatureBlock(this.signature, this.algoId);

  final Uint8List signature;
  final int algoId;

  int get size => 12 + signature.lengthInBytes;

  void write(OutputStreamBase output) {
    output.writeUint32(8 + signature.lengthInBytes);
    output.writeUint32(algoId);
    output.writeUint32(signature.lengthInBytes);
    output.writeBytes(signature);
  }
}

class PublicKeyBlock {
  const PublicKeyBlock(this.publicKey);

  final PublicKey publicKey;

  int get size => 4 + publicKey.toDer().lengthInBytes;

  void write(OutputStreamBase output) {
    final publicKeyInDer = publicKey.toDer();
    output.writeUint32(publicKeyInDer.lengthInBytes);
    output.writeBytes(publicKeyInDer);
  }
}
