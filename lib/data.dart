import 'package:flutter/material.dart';
import 'package:nucleon/nucleon.dart';

// currently only used for the SettingsDialog() inside of the custom window builder
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const double kWindowRadius = 40.0;

NAppData kAppData = NAppData(
  appName: "Journal",
  appVersion: "v0.0.1",
  developer: "NucleonInteractive",
  developerMail: "nucleoninteractive@gmail.com",
  year: "2026",
);

const String byDev = "by Nucleon";

final DateTime kMinDateTime = DateTime(2000);

double getToastWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width / 4.0;
