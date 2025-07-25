import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/data.dart';
import 'package:journal/core/core.dart';
import 'package:journal/widgets/dialog/closing_dialog.dart';
import 'package:journal/widgets/dialog/saving_dialog.dart';
import 'package:journal/widgets/dialog/settings_dialog.dart';

class CustomWindowCaption extends StatefulWidget {
  const CustomWindowCaption({
    super.key,
    required this.title,
    required this.providedCore,
  });

  final Widget title;
  final Core providedCore;

  @override
  State<CustomWindowCaption> createState() => _CustomWindowCaptionState();
}

class _CustomWindowCaptionState extends State<CustomWindowCaption>
    with WindowListener {
  bool get showSaveButton =>
      widget.providedCore.state.isAppLoaded &&
      widget.providedCore.hasUnsavedChanges &&
      !widget.providedCore.state.isSaving;

  bool get showSettingsButton =>
      widget.providedCore.state.isAppLoaded &&
      !widget.providedCore.state.isSettingsPanelOpen &&
      !widget.providedCore.state.isSaving;

  void openSettingsPanel() {
    widget.providedCore.state.isSettingsPanelOpen = true;
    widget.providedCore.updateApp();
    nShowDialog(
      context: navigatorKey.currentContext!,
      dialog: SettingsDialog(),
      after: () {
        widget.providedCore.state.isSettingsPanelOpen = false;
        widget.providedCore.updateApp();
      },
    );
  }

  void save() {
    widget.providedCore.state.isSaving = true;
    widget.providedCore.updateApp();
    nShowDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      dialog: SavingDialog(providedCore: widget.providedCore),
      after: () {
        widget.providedCore.state.isSaving = false;
        widget.providedCore.updateApp();
      },
    );
  }

  void closeApp() {
    if (widget.providedCore.state.isSaving) return;
    if (!widget.providedCore.hasUnsavedChanges) {
      windowManager.close();
      return;
    }
    nShowDialog(
      context: navigatorKey.currentContext!,
      dialog: ClosingDialog(
        closeApp: (close) {
          if (close) windowManager.close();
        },
      ),
      after: () {},
    );
  }

  Future minimizeApp() async {
    bool isMinimized = await windowManager.isMinimized();
    if (isMinimized) {
      windowManager.restore();
    } else {
      windowManager.minimize();
    }
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: kWindowRadius),
                      child: DefaultTextStyle(
                        style: nTitleFontTextStyle(
                          context: context,
                          invert: false,
                          desktopFS: true,
                        ),
                        child: widget.title,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          showSaveButton
              ? NIconCircle(
                  iconData: FeatherIcons.save,
                  invertColors: true,
                  onPressed: () => save(),
                )
              : const SizedBox(width: 40.0),
          SizedBox(width: kDefaultPadding),
          showSettingsButton
              ? NIconCircle(
                  iconData: FeatherIcons.settings,
                  invertColors: true,
                  onPressed: () => openSettingsPanel(),
                )
              : const SizedBox(width: 40.0),
          SizedBox(width: kDefaultPadding),
          widget.providedCore.state.isAppLoaded
              ? Container(
                  width: 1.0,
                  height: kDefaultPadding,
                  color: Theme.of(context).focusColor,
                )
              : const SizedBox(),
          SizedBox(width: kDefaultPadding),
          NIconCircle(
            iconData: FeatherIcons.minimize2,
            invertColors: true,
            onPressed: () async => await minimizeApp(),
          ),
          SizedBox(width: kDefaultPadding),
          NIconCircle(
            iconData: FeatherIcons.x,
            invertColors: true,
            onPressed: () => closeApp(),
          ),
          SizedBox(width: kWindowRadius),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
