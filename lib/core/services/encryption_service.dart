import 'package:journal/core/classes/encrypter.dart';

/// Custom Encrypter implementation must have following "architecture":
///
/// class Encrypter {
///   static String encryptionKey = '...';
///
///   static String encryptData(String data, String password) {
///     ...
///     return enryptedData;
///   }
///
///   static String encryptData(String encoded, String password) {
///     ...
///     return decodedData;
///   }
/// }
///

class EncryptionService {
  static String encryptionKey() => Encrypter.encryptionKey;

  static String encryptData(String data, String password) =>
      Encrypter.encryptData(data, password);

  static String decryptData(String encoded, String password) =>
      Encrypter.decryptData(encoded, password);

  // Hide Password in json
  static String encryptPassword(String password) {
    return EncryptionService.encryptData(
      password,
      EncryptionService.encryptionKey(),
    );
  }

  static String decryptPassword(String encoded) {
    return EncryptionService.decryptData(
      encoded,
      EncryptionService.encryptionKey(),
    );
  }
}
