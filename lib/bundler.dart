import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class Bundler {
  final _iv = Uint8List.fromList(List.from([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]));
  Future<List<int>> aesEncrypt(List<int> bytes,String password) async {
    final key = Key.fromUtf8(password);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(bytes,iv: IV(_iv));
    return encrypted.bytes;
  }
  Future<List<int>> aesDecrypt(List<int> encrypted,String password) async {
    final key = Key.fromUtf8(password);
    final encrypter = Encrypter(AES(key,mode: AESMode.cbc));
    final decrypted = encrypter.decryptBytes(Encrypted(Uint8List.fromList(encrypted)),iv: IV(_iv));
    return decrypted;
  }
}
