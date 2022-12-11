import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bundler/bundler.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length < 3) {
    print('Usage: bundler:unpack <input> <output> <password>');
    exit(1);
  }
  final encryptedZip = arguments[0];
  final outputDir = arguments[1];
  final password = arguments[2];
  if (password.length != 16) {
    print("Password length must be 16 characters long.");
    exit(1);
  }
  final encryptedZipFile = File(encryptedZip);
  final outputDirFile = Directory(outputDir);
  if (!encryptedZipFile.existsSync()){
    print('Encrypted zip file does not exist');
    return;
  }
  if (outputDirFile.existsSync()){
    print('Output directory already exists');
    return;
  }else {
    outputDirFile.createSync();
  }
  //aes decrypt the file
  final encryptedZipBytes = await encryptedZipFile.readAsBytes();
  final decryptedBytes = await Bundler().aesDecrypt(encryptedZipBytes,password);
 // temp file
  final tempFile = File('${encryptedZipFile.path}.temp');
  await tempFile.writeAsBytes(decryptedBytes);
  // unzip the file
  print("Unzipping assets...");
  final archive = ZipDecoder();
  final zipFile = await archive.decodeBytes(decryptedBytes);
  for (final file in zipFile) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      final outputFile = File('$outputDir/$filename');
      await outputFile.create(recursive: true);
      await outputFile.writeAsBytes(data);
    } else {
      final dir = Directory('$outputDir/$filename');
      await dir.create(recursive: true);
    }
  }
  // delete temp file
  await tempFile.delete();
  print("Assets unzipped");
}
