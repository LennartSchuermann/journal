import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';

import 'package:nucleon/nucleon.dart';

PinTheme defaultPinTheme(
  BuildContext context, {
  bool invert = false,
  double size = 56.0,
  double borderRadius = 20.0,
}) => PinTheme(
  width: size,
  height: size,
  textStyle: nSubheadingFontTextStyle(context: context, invert: true),
  decoration: BoxDecoration(
    border: Border.all(
      color: invert
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).focusColor,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

PinTheme submittedPinTheme(
  BuildContext context, {
  required PinTheme defaultPinTheme,
  bool invert = false,
}) => defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration!.copyWith(
    color: invert
        ? Theme.of(context).scaffoldBackgroundColor
        : Theme.of(context).focusColor,
  ),
);

PinTheme focusedPinTheme(
  BuildContext context, {
  required PinTheme defaultPinTheme,
  double borderRadius = 5.0,
}) => defaultPinTheme.copyDecorationWith(
  border: Border.all(color: NColorPalette.electonBlue.getColor()),
  borderRadius: BorderRadius.circular(borderRadius),
);
