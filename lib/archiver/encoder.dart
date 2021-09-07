import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:agent_dart/agent/agent.dart';
import 'package:archive/archive_io.dart';
import 'package:agent_dart/utils/extension.dart';
import 'signing_block.dart';

class ZipSigningBlock {
  final List<SigningBlock> signingBlocks;
  ZipSigningBlock.create({
    required this.signingBlocks,
  });

  void write(OutputStreamBase output) {
    output.writeUint32(getSize());

    for (var sb in signingBlocks) {
      output.writeUint32(sb.getSize()); // Uint64?? 4 bytes
      writeID(output); // 4 bytes
      sb.write(output);
    }
    output.writeUint32(getSize());
    output.writeBytes('RPK Sig Block 42'.plainToU8a(), 16);
  }

  int getSize() {
    var size = 0;
    for (var sb in signingBlocks) {
      size += (sb.getSize() + 12); // Uint64 should + 32
    }

    return size;
  }

  void writeID(OutputStreamBase output) {
    output.writeUint32(0x01000101);
  }
}

class SigningBlockEncoder extends ZipEncoder {
  late final ZipSigningBlock signingBlock;
  SigningBlockEncoder.create(
      {required Uint8List message,
      required Uint8List signature,
      required PublicKey publicKey,
      int algoId = 0x0201})
      : super() {
    signingBlock = ZipSigningBlock.create(signingBlocks: [
      SigningBlock.create(messages: [message], signatures: [signature], publicKeys: [publicKey])
    ]);
  }

  void writeBlock(OutputStreamBase output) {
    signingBlock.write(output);
  }
}

class SingingBlockZipFileEncoder extends ZipFileEncoder {
  @override
  late String zip_path;
  late OutputFileStream _output;
  late final SigningBlockEncoder _encoder;

  SingingBlockZipFileEncoder(SigningBlockEncoder encoder) : super() {
    _encoder = encoder;
  }

  static const int STORE = 0;
  static const int GZIP = 1;

  @override
  void zipDirectory(Directory dir, {String? filename, int? level, bool followLinks = true}) {
    final dirPath = dir.path;
    final zip_path = filename ?? '$dirPath.zip';
    level ??= GZIP;
    create(zip_path, level: level);
    addDirectory(dir, includeDirName: false, level: level, followLinks: followLinks);
    close();
  }

  @override
  void open(String zip_path) => create(zip_path);

  @override
  void create(String zip_path, {int? level}) {
    this.zip_path = zip_path;
    _output = OutputFileStream(zip_path);
    _encoder.startEncode(_output, level: level);
  }

  @override
  void addDirectory(Directory dir,
      {bool includeDirName = true, int? level, bool followLinks = true}) {
    // _encoder.signingBlock.write(_output);
    List files = dir.listSync(recursive: true, followLinks: followLinks);
    for (var file in files) {
      if (file is! File) {
        continue;
      }

      final f = file;
      final dir_name = path.basename(dir.path);
      final rel_path = path.relative(f.path, from: dir.path);
      addFile(f, includeDirName ? (dir_name + '/' + rel_path) : rel_path, level);
    }
  }

  @override
  void addFile(File file, [String? filename, int? level = GZIP]) {
    var file_stream = InputFileStream.file(file);
    var archiveFile =
        ArchiveFile.stream(filename ?? path.basename(file.path), file.lengthSync(), file_stream);

    if (level == STORE) {
      archiveFile.compress = false;
    }

    archiveFile.lastModTime = file.lastModifiedSync().millisecondsSinceEpoch;
    archiveFile.mode = file.statSync().mode;

    _encoder.addFile(archiveFile);
    file_stream.close();
  }

  @override
  void addArchiveFile(ArchiveFile file) {
    _encoder.addFile(file);
  }

  @override
  void close() {
    _encoder.writeBlock(_output);
    _encoder.endEncode();
    _output.close();
  }
}
