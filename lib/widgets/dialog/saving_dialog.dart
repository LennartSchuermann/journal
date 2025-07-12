import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:journal/core/core.dart';
import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

class SavingDialog extends StatefulWidget {
  const SavingDialog({super.key, required this.providedCore});

  final Core providedCore;

  @override
  State<SavingDialog> createState() => _SavingDialogState();
}

class _SavingDialogState extends State<SavingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Theme.of(context).focusColor,
      child: contentBox(context),
    );
  }

  Future<bool> waitFor() async {
    await Future.delayed(Duration(milliseconds: 800));
    return true;
  }

  Widget savedConfirmationWidget() {
    // !!!!! Extremly Bad Code!!!!! -> FutureBuilder inside of another FutureBuilder....
    // wait for x Seconds & display saving complete...
    return FutureBuilder(
      future: waitFor(),
      builder: (BuildContext ctx, AsyncSnapshot snp) {
        if (snp.hasData) Navigator.pop(context);
        return Column(
          children: [
            NSubheadingFont(
              "Saved Data",
              color: NColorPalette.mintLeaf.getColor(),
            ),
            const SizedBox(height: kDefaultPadding),
            Icon(
              FeatherIcons.check,
              size: 41.0,
              color: NColorPalette.mintLeaf.getColor(),
            ),
          ],
        );
      },
    );
  }

  contentBox(context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 4,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<bool>(
                    future: widget.providedCore.saveData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData && snapshot.data!) {
                            return savedConfirmationWidget();
                          }
                          return Column(
                            children: [
                              NSubheadingFont("Saving Data", invert: true),
                              const SizedBox(height: kDefaultPadding),
                              NProgressIndicator(
                                invert: true,
                                strokeWidth: 2.0,
                              ),
                            ],
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
