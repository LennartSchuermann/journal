import 'package:flutter/material.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/widgets/utils/pin_code_themes.dart';
import 'package:pinput/pinput.dart';

import 'package:tuple/tuple.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/data.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late Core core;

  late TextEditingController pinController;
  late PinTheme defaultPT;

  void changePassword(String pin) {
    core.appData.password = pin;
    core.setUnsavedChanges();
    nShowToast(
      context,
      title: "Password Changed!",
      description: "",
      type: ToastType.success,
      widthOverride: getToastWidth(context),
    );
    pinController.clear();
  }

  @override
  void initState() {
    super.initState();

    core = CoreManager.instance.core;
    pinController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    defaultPT = defaultPinTheme(
      context,
      invert: true,
      size: 32.0,
      borderRadius: 5.0,
    );
    return NPopUpDialog(
      title: "Settings",
      invert: true,
      maxWidth: MediaQuery.sizeOf(context).width / 2,
      content: [
        Padding(
          padding: const EdgeInsets.only(
            left: kDefaultPadding * 4,
            right: kDefaultPadding * 4,
          ),
          child: Column(
            children: [
              /*  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NContentFont("Use Git", invert: true),
                  NSwitch(
                    initValue: core.appData.useGit,
                    invert: true,
                    onChanged: (newVal) => setState(() {
                      core.setUnsavedChanges();
                      core.appData.useGit = newVal;
                    }),
                    colors: Tuple2(
                      NColorPalette.mintLeaf.getColor(),
                      NColorPalette.electonBlue.getColor(),
                    ),
                  ),
                ],
              ), */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NContentFont("Change Password", invert: true),
                  Pinput(
                    defaultPinTheme: defaultPT,
                    focusedPinTheme: focusedPinTheme(
                      context,
                      defaultPinTheme: defaultPT,
                    ),
                    submittedPinTheme: submittedPinTheme(
                      context,
                      defaultPinTheme: defaultPT,
                    ),
                    controller: pinController,
                    validator: (s) => null,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: false,
                    onCompleted: (pin) => changePassword(pin),
                  ),
                ],
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NContentFont("Use Encryption", invert: true),
                  NSwitch(
                    initValue: core.appData.useEncryption,
                    invert: true,
                    onChanged: (newVal) => setState(() {
                      core.setUnsavedChanges();
                      core.appData.useEncryption = newVal;
                    }),
                    colors: Tuple2(
                      NColorPalette.mintLeaf.getColor(),
                      NColorPalette.electonBlue.getColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: kDefaultPadding),
        // App Meta data
        NCaptionFont(
          "${kAppData.appName} by ${kAppData.developer}, ${kAppData.year} | ${kAppData.appVersion}",
          invert: true,
        ),
      ],
    );
  }
}
