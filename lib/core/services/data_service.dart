import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:journal/core/services/encryption_service.dart';

class DataService {
  static String defaultPath = "${Directory.current.path}\\data\\journal.json";
  static String encryptedFilePath =
      "${Directory.current.path}\\data\\journal.jrnl";

  static Future<bool> saveData({
    required List<Map<String, dynamic>> jsonData,
    required String password,
    bool useEncryption = false,
  }) async {
    try {
      if (useEncryption) {
        // Encrypt Data & Append To Custom File Format
        for (int i = 0; i < jsonData.length; i++) {
          String encJsonData = jsonEncode(jsonData[i]);
          Uint8List encodedData = _stringToBytes(
            EncryptionService.encryptData(encJsonData, password),
          );
          await _appendEncryptedJson(
            encodedData,
            mode: i == 0 ? FileMode.write : FileMode.append,
          );
        }
      } else {
        await _saveJsonFile(jsonData);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> loadData({
    required String password,
    bool useEncryption = false,
  }) async {
    try {
      if (useEncryption) {
        List<Map<String, dynamic>> jsonData = List.empty(growable: true);

        List<Uint8List> strings = await _readEncryptedJsons();
        for (final s in strings) {
          String strData = _bytesToString(s);
          String decryptedData = EncryptionService.decryptData(
            strData,
            password,
          );
          jsonData.add(jsonDecode(decryptedData));
        }
        return jsonData;
      } else {
        return await _readJsonFromFile();
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static bool usingEncryption() {
    final File secureFile = File(encryptedFilePath);
    final File defaultFile = File(defaultPath);

    final bool doesSecureFileExist = secureFile.existsSync();
    final bool doesDefaultFileExist = defaultFile.existsSync();

    if (doesSecureFileExist && doesDefaultFileExist) {
      // select the more recent one
      if (secureFile.lastModifiedSync().isBefore(
        defaultFile.lastModifiedSync(),
      )) {
        return false;
      }

      // prio for secure file (if  last modified is the same)
      return true;
    } else if (doesSecureFileExist) {
      return true;
    } else {
      return false;
    }
  }

  static bool doesDataExist() {
    final bool doesSecureFileExist = File(encryptedFilePath).existsSync();
    final bool doesDefaultFileExist = File(defaultPath).existsSync();

    return doesSecureFileExist || doesDefaultFileExist;
  }

  // No Encryption
  static Future<void> _saveJsonFile(List<Map<String, dynamic>> jsonData) async {
    final file = File(defaultPath);
    final jsonString = jsonEncode(jsonData);
    await file.writeAsString(jsonString);
  }

  static Future<List<Map<String, dynamic>>> _readJsonFromFile() async {
    final file = File(defaultPath);
    final jsonString = await file.readAsString();
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }

  // Using Encryption
  static Future<void> _appendEncryptedJson(
    Uint8List encryptedData, {
    FileMode mode = FileMode.append,
  }) async {
    final file = File(encryptedFilePath);
    final raf = await file.open(mode: mode); // append mode

    final lengthBytes = ByteData(4)..setUint32(0, encryptedData.lengthInBytes);
    await raf.writeFrom(lengthBytes.buffer.asUint8List());
    await raf.writeFrom(encryptedData);

    await raf.close();
  }

  static Future<List<Uint8List>> _readEncryptedJsons() async {
    final file = File(encryptedFilePath);
    final contents = await file.readAsBytes();
    final List<Uint8List> result = [];

    int offset = 0;
    while (offset + 4 <= contents.length) {
      final lengthBytes = contents.sublist(offset, offset + 4);
      final length = ByteData.sublistView(lengthBytes).getUint32(0);
      offset += 4;

      if (offset + length <= contents.length) {
        final encrypted = contents.sublist(offset, offset + length);
        result.add(Uint8List.fromList(encrypted));
        offset += length;
      } else {
        throw FormatException('Corrupted file: incomplete entry');
      }
    }

    return result;
  }

  // ------------- Helper -------------
  static Uint8List _stringToBytes(String encryptedData) {
    return utf8.encode(encryptedData);
  }

  static String _bytesToString(Uint8List bytes) {
    return utf8.decode(bytes);
  }
}
