import 'package:flutter/material.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

class ClosingDialog extends StatefulWidget {
  const ClosingDialog({super.key, required this.closeApp});

  final ValueChanged<bool> closeApp;

  @override
  State<ClosingDialog> createState() => _ClosingDialogState();
}

class _ClosingDialogState extends State<ClosingDialog> {
  @override
  Widget build(BuildContext context) {
    return NPopUpDialog(
      title: "Close App",
      invert: true,
      maxWidth: MediaQuery.sizeOf(context).width / 2.0,
      content: [
        NContentFont(
          "Are you sure you want to close the app? You have unsaved changes.",
          invert: true,
        ),
        const SizedBox(height: kDefaultPadding),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: NButton(
            "Yes, Close App",
            tooltip: "Close App without saving",
            width: 250.0,
            invert: true,
            onPressed: () {
              widget.closeApp(true);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
