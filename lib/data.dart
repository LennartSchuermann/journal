import 'package:flutter/material.dart';

import 'package:markdown_widget/markdown_widget.dart';

import 'package:nucleon/nucleon.dart';
import 'package:tuple/tuple.dart';

// currently only used for the SettingsDialog() inside of the custom window builder
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const double kWindowRadius = 40.0;

NAppData kAppData = NAppData(
  appName: "Journal",
  appVersion: "v0.0.2",
  developer: "NucleonInteractive",
  developerMail: "nucleoninteractive@gmail.com",
  year: "2026",
);

const String byDev = "by Nucleon";

final DateTime kMinDateTime = DateTime(2000);

double getToastWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width / 4.0;

final Tuple2<Color, Color> kPrimaryColors = Tuple2<Color, Color>(
  NColorPalette.mintLeaf.getColor(), // Light Mode
  NColorPalette.electonBlue.getColor(), // Dark Mode
);

MarkdownConfig markdownConfig({
  required BuildContext context,
  required Function(String) onLinkTap,
}) => MarkdownConfig(
  // TODO fix todo lists... padding??? & create config
  configs: [
    TableConfig(), // TODO Table Config ?
    ListConfig(),
    HrConfig(color: Theme.of(context).focusColor),
    H1Config(style: nBrandFontTextStyle(context: context)),
    H2Config(style: nTitleFontTextStyle(context: context, invert: false)),
    H3Config(style: nSubheadingFontTextStyle(context: context, invert: false)),
    LinkConfig(
      style: nContentFontTextStyle(
        context: context,
        color: NColorPalette.electonBlue.getColor(),
        invert: false,
      ),
      onTap: (url) => onLinkTap(url),
    ),
    PConfig(textStyle: nContentFontTextStyle(context: context, invert: false)),
  ],
);
