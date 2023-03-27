import 'dart:io';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;

import 'signing_block.dart';

class ZipSigningBlock {
  const ZipSigningBlock.create({required this.signingBlocks});

  final List<SigningBlock> signingBlocks;

  void write(OutputStreamBase output) {
    output.writeUint32(getSize());

    for (final sb in signingBlocks) {
      output.writeUint32(sb.getSize()); // Uint64?? 4 bytes
      writeID(output); // 4 bytes
      sb.write(output);
    }
    output.writeUint32(getSize());
    output.writeBytes('RPK Sig Block 42'.plainToU8a(), 16);
  }

  int getSize() {
    int size = 0;
    for (final sb in signingBlocks) {
      size += sb.getSize() + 12; // Uint64 should + 32
    }
    return size;
  }

  void writeID(OutputStreamBase output) {
    output.writeUint32(0x01000101);
  }
}

class SigningBlockEncoder extends ZipEncoder {
  SigningBlockEncoder.create({
    required Uint8List message,
    required Uint8List signature,
    required PublicKey publicKey,
    int algoId = 0x0201,
  }) : signingBlock = ZipSigningBlock.create(
          signingBlocks: [
            SigningBlock.create(
              messages: [message],
              signatures: [signature],
              publicKeys: [publicKey],
            )
          ],
        );

  final ZipSigningBlock signingBlock;

  void writeBlock(OutputStreamBase output) {
    signingBlock.write(output);
  }
}

class SingingBlockZipFileEncoder extends ZipFileEncoder {
  SingingBlockZipFileEncoder(SigningBlockEncoder encoder) : _encoder = encoder;

  late OutputFileStream _output;
  late final SigningBlockEncoder _encoder;

  static const int store = 0;
  static const int gzip = 1;

  @override
  void zipDirectory(
    Directory dir, {
    String? filename,
    int? level,
    bool followLinks = true,
    DateTime? modified,
  }) {
    final dirPath = dir.path;
    final zipPath = filename ?? '$dirPath.zip';
    level ??= gzip;
    create(zipPath, level: level);
    addDirectory(
      dir,
      includeDirName: false,
      level: level,
      followLinks: followLinks,
    );
    close();
  }

  @override
  void open(String zipPath) => create(zipPath);

  @override
  void create(String zipPath, {int? level, DateTime? modified}) {
    this.zipPath = zipPath;
    _output = OutputFileStream(zipPath);
    _encoder.startEncode(_output, level: level);
  }

  @override
  Future<void> addDirectory(
    Directory dir, {
    bool includeDirName = true,
    int? level,
    bool followLinks = true,
  }) async {
    final List files = dir.listSync(recursive: true, followLinks: followLinks);
    final futures = <Future<void>>[];
    for (final file in files) {
      if (file is! File) {
        continue;
      }
      final f = file;
      final dirName = path.basename(dir.path);
      final relativePath = path.relative(f.path, from: dir.path);
      futures.add(
        addFile(
          f,
          includeDirName ? ('$dirName/$relativePath') : relativePath,
          level,
        ),
      );
    }
    await Future.wait(futures);
  }

  @override
  Future<void> addFile(File file, [String? filename, int? level = gzip]) async {
    final fileStream = InputFileStream(file.path);
    final archiveFile = ArchiveFile.stream(
      filename ?? path.basename(file.path),
      file.lengthSync(),
      fileStream,
    );

    if (level == store) {
      archiveFile.compress = false;
    }

    archiveFile.lastModTime = file.lastModifiedSync().millisecondsSinceEpoch;
    archiveFile.mode = file.statSync().mode;

    _encoder.addFile(archiveFile);
    await fileStream.close();
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
