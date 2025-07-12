import 'package:flutter/material.dart';
import 'package:journal/widgets/utils/pin_code_themes.dart';

import 'package:pinput/pinput.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/core/classes/app_data.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';

class PinInput extends StatefulWidget {
  const PinInput({super.key, required this.onComplete});

  final Function(AppData) onComplete;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  Future<bool> load(String? pin) async {
    if (pin == null) return false;
    Core core = CoreManager.instance.core;

    // Load Data
    AppData? data = await core.loadData(pin);

    if (context.mounted && data != null) {
      core.login();
      widget.onComplete(data);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    PinTheme defaultPT = defaultPinTheme(context);
    return Pinput(
      defaultPinTheme: defaultPT,
      focusedPinTheme: focusedPinTheme(context, defaultPinTheme: defaultPT),
      submittedPinTheme: submittedPinTheme(context, defaultPinTheme: defaultPT),
      validator: (s) => null,
      obscureText: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: false,
      onCompleted: (pin) async {
        //if (!correct(pin)) return;
        if (!await load(pin) && context.mounted) {
          nShowToast(
            context,
            title: "Incorrect Pin Code",
            description: "",
            type: ToastType.error,
            widthOverride:
                MediaQuery.sizeOf(context).width / 4.0 - 4.0 * kDefaultPadding,
          );
        }
      },
    );
  }
}
