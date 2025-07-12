import 'package:flutter_test/flutter_test.dart';
import 'package:journal/core/classes/app_data.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';

void main() {
  Core core = Core();
  CoreManager.setCore(core);

  String? pin = '2332';

  group('Core & Services: ', () {
    test('User Load & Login', () async {
      AppData? appData = await core.loadData(pin);

      if (appData == null) throw Exception("NO APPDATA ???");
      core.login();

      expect('a', 'a');
    });
  });
}
