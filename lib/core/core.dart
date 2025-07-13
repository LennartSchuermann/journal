import 'package:flutter/material.dart';

import 'package:journal/core/classes/app_data.dart';
import 'package:journal/core/classes/journal/journal_track.dart';
import 'package:journal/core/services/data_service.dart';
import 'package:journal/core/services/git_service.dart';
import 'package:journal/core/services/journal_service.dart';

class Core extends ChangeNotifier {
  // Loadable Objects
  late AppData _data;

  // Tracks
  late Journaltrack _journaltrack;

  // Services
  late JournalService journalService;
  late DataService dataService;
  late GitService gitService;

  // states
  // // TODO move to wrapper class...
  bool isAppLoaded = false;
  bool isSettingsPanelOpen = false;
  bool isSaving = false;
  bool _unsavedChanges = false;

  bool get hasUnsavedChanges => _unsavedChanges;
  void setUnsavedChanges() {
    _unsavedChanges = true;
    updateApp();
  }

  AppData get appData => _data;

  Future<AppData?> loadData(String password) async {
    bool usingEncryption = DataService.usingEncryption();

    List<Map<String, dynamic>>? loadedData = await DataService.loadData(
      password: password,
      useEncryption: usingEncryption,
    );

    if (loadedData != null) {
      debugPrint("<J-CORE> Save Data Found!");
      _data = AppData.fromJson(loadedData[0]);
      _journaltrack = Journaltrack.fromJson(loadedData[1]);

      if (password != _data.password) return null;
    } else if (!DataService.doesDataExist()) {
      debugPrint("<J-CORE> No Save Data Found! - Creating User");
      _data = AppData(password: password);
      _journaltrack = Journaltrack();
    } else {
      return null;
    }

    return _data;
  }

  Future<bool> saveData() async {
    _unsavedChanges = false;

    debugPrint("<J-CORE> Saving Data...");

    bool didSave = await DataService.saveData(
      jsonData: [_data.toJson(), _journaltrack.toJson()],
      password: _data.password,
      useEncryption: _data.useEncryption,
    );

    return didSave;
  }

  void login() {
    debugPrint("<J-CORE> Log-In User...");
    _data.login();

    isAppLoaded = true;

    _setupServices();
    updateApp();
  }

  void updateApp() => notifyListeners();

  void _setupServices() {
    debugPrint("<J-CORE> Getting Services...");
    journalService = JournalService(journaltrack: _journaltrack);
  }
}
