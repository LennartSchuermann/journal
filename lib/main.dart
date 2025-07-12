import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/test/test_data.dart';

import 'package:window_manager/window_manager.dart';

import 'package:nucleon/nucleon.dart';

import 'package:journal/data.dart';
import 'package:journal/screens/login_screen.dart';
import 'package:journal/widgets/utils/custom_window_caption.dart';

// currently only used for the SettingsDialog() inside of the custom window builder
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  windowManager.ensureInitialized();

  Window.initialize();
  Window.setEffect(effect: WindowEffect.transparent);

  WindowOptions windowOptions = WindowOptions(
    size: Size(1280, 832),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    fullScreen: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
    // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setResizable(false);
    await windowManager.setMaximizable(false);
    await windowManager.setMinimizable(false);
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(false);
    windowManager.show();
  });

  // Nucleon
  await initNucleon();

  // Core
  Core core = Core();
  CoreManager.setCore(core);

  testDataSetup();

  runApp(ChangeNotifierProvider(create: (_) => core, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${kAppData.appName} by Nucleon',
      theme: nLightTheme,
      darkTheme: nDarkTheme,
      navigatorKey: navigatorKey,
      home: LoginScreen(),
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      // Custom Windows Nav Bar
      color: Colors.transparent,
      builder: (context, child) {
        final providedCore = Provider.of<Core>(context); // Listens to changes!

        return ClipRRect(
          borderRadius: BorderRadius.circular(kWindowRadius),
          child: Stack(
            children: [
              /// Fake window border
              Container(
                margin: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kWindowRadius),
                  child: child!,
                ),
              ),

              /// Window Caption
              SizedBox(
                width: double.infinity,
                height: 96,
                child: CustomWindowCaption(
                  providedCore: providedCore,
                  title: Row(
                    children: [
                      NTitleFont(kAppData.appName),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: NCaptionFont("by Nucleon"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
