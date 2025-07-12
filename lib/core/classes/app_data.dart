import 'package:journal/core/services/encryption_service.dart';

class AppData {
  // infos
  late DateTime lastTimeOnline;

  // data
  late String password;

  // Settings
  bool useGit = false;
  bool useEncryption = true;

  AppData({
    DateTime? lastTimeOnline,
    required this.password,
    this.useGit = false,
    this.useEncryption = true,
  }) {
    this.lastTimeOnline = lastTimeOnline ?? DateTime.now().toUtc();
  }

  void login() {
    lastTimeOnline = DateTime.now().toUtc();
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'lastTimeOnline': lastTimeOnline.toIso8601String(),
      'password': EncryptionService.encryptPassword(password),
      'useGit': useGit,
      'useEncryption': useEncryption,
    };
  }

  // Create from JSON
  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      lastTimeOnline:
          DateTime.tryParse(json['lastTimeOnline'] ?? '') ??
          DateTime.now().toUtc(),
      password: json['password'] != null
          ? EncryptionService.decryptPassword(json['password'])
          : '',
      useGit: json['useGit'] ?? false,
      useEncryption: json['useEncryption'] ?? true,
    );
  }
}
