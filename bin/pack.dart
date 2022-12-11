import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bundler/bundler.dart';
Future<void> main(List<String> arguments) async {
  if (arguments.length < 3) {
    print('Usage: bundler:pack <input> <output> <password>');
    exit(1);
  }
  final assetPath = arguments[0];
  final outputFilePath = arguments[1];
  final password = arguments[2];
  if (password.length != 16) {
    print("Password length must be 16");
    exit(1);
  }
  final assetDir = Directory(assetPath);
  final outputFile = File(outputFilePath);
  if (!assetDir.existsSync()){
    print('Asset directory does not exist');
    return;
  }
  if (outputFile.existsSync()){
    print('Output file already exists');
    return;
  }
  print("Compressing assets...\nIt may take a while...");
  final archive = ZipFileEncoder();
  archive.create(outputFilePath);
  archive.addDirectory(assetDir);
  archive.close();

  //aes encrypt the file
  final outputFileBytes = await outputFile.readAsBytes();
  final encryptedBytes = await Bundler().aesEncrypt(outputFileBytes,password);
  await outputFile.writeAsBytes(encryptedBytes);
  print("Assets compressed and encrypted");
}

