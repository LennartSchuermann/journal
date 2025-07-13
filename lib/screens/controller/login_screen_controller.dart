import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/core/classes/app_data.dart';
import 'package:journal/core/services/data_service.dart';

class LoginScreenController {
  late Core _core;

  LoginScreenController() {
    _core = CoreManager.instance.core;
  }

  /// returns true if load was successful
  Future<bool> load(String? pin) async {
    if (pin == null) return false;

    // Load Data
    AppData? appData = await _core.loadData(pin);

    if (appData != null) {
      _core.login();
      return true;
    }
    return false;
  }

  bool get firstAppUse => !DataService.doesDataExist();
}
