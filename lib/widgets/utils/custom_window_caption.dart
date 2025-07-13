import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:journal/core/core.dart';
import 'package:journal/data.dart';
import 'package:journal/main.dart';
import 'package:journal/widgets/dialog/closing_dialog.dart';
import 'package:journal/widgets/dialog/saving_dialog.dart';
import 'package:journal/widgets/dialog/settings_dialog.dart';
import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';
import 'package:window_manager/window_manager.dart';

class CustomWindowCaption extends StatefulWidget {
  const CustomWindowCaption({
    super.key,
    this.title,
    required this.providedCore,
  });

  final Widget? title;
  final Core providedCore;

  @override
  State<CustomWindowCaption> createState() => _CustomWindowCaptionState();
}

class _CustomWindowCaptionState extends State<CustomWindowCaption>
    with WindowListener {
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
                        child: widget.title ?? Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.providedCore.isAppLoaded &&
                  widget.providedCore.hasUnsavedChanges &&
                  !widget.providedCore.isSaving
              ? NIconCircle(
                  iconData: FeatherIcons.save,
                  invertColors: true,
                  onPressed: () {
                    widget.providedCore.isSaving = true;
                    widget.providedCore.updateApp();
                    nShowDialog(
                      barrierDismissible: false,
                      context: navigatorKey.currentContext!,
                      dialog: SavingDialog(providedCore: widget.providedCore),
                      after: () {
                        widget.providedCore.isSaving = false;
                        widget.providedCore.updateApp();
                      },
                    );
                  },
                )
              : const SizedBox(width: 40.0),
          SizedBox(width: kDefaultPadding),
          widget.providedCore.isAppLoaded &&
                  !widget.providedCore.isSettingsPanelOpen
              ? NIconCircle(
                  iconData: FeatherIcons.settings,
                  invertColors: true,
                  onPressed: () {
                    widget.providedCore.isSettingsPanelOpen = true;
                    widget.providedCore.updateApp();
                    nShowDialog(
                      context: navigatorKey.currentContext!,
                      dialog: SettingsDialog(),
                      after: () {
                        widget.providedCore.isSettingsPanelOpen = false;
                        widget.providedCore.updateApp();
                      },
                    );
                  },
                )
              : const SizedBox(width: 40.0),
          SizedBox(width: kDefaultPadding),
          widget.providedCore.isAppLoaded
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
            onPressed: () async {
              bool isMinimized = await windowManager.isMinimized();
              if (isMinimized) {
                windowManager.restore();
              } else {
                windowManager.minimize();
              }
            },
          ),

          SizedBox(width: kDefaultPadding),
          NIconCircle(
            iconData: FeatherIcons.x,
            invertColors: true,
            onPressed: () {
              if (!widget.providedCore.hasUnsavedChanges) windowManager.close();
              nShowDialog(
                context: navigatorKey.currentContext!,
                dialog: ClosingDialog(
                  closeApp: (close) {
                    if (close) windowManager.close();
                  },
                ),
                after: () {},
              );
            },
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
