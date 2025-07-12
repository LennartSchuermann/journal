import 'package:journal/core/core.dart';

class CoreManager {
  static final CoreManager _instance = CoreManager._internal();
  static CoreManager get instance => _instance;

  Core get core => _core;

  late Core _core;

  CoreManager._internal();

  static void setCore(Core core) {
    _instance._core = core;
  }
}
