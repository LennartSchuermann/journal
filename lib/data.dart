import 'package:flutter/material.dart';
import 'package:nucleon/nucleon.dart';

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
