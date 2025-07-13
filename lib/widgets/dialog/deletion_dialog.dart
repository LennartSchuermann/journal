import 'package:flutter/widgets.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/core/classes/journal/journal_entry.dart';

class DeletionDialog extends StatefulWidget {
  const DeletionDialog({super.key, required this.entry, required this.delete});

  final JournalEntry entry;
  final ValueChanged<bool> delete;

  @override
  State<DeletionDialog> createState() => _DeletionDialogState();
}

class _DeletionDialogState extends State<DeletionDialog> {
  @override
  Widget build(BuildContext context) {
    return NPopUpDialog(
      title: "Delete Journal Entry",
      invert: true,
      maxWidth: MediaQuery.sizeOf(context).width / 2.0,
      content: [
        NTitleFont(formatDate(widget.entry.dateTime.toLocal()), invert: true),
        const SizedBox(height: kDefaultPadding),
        NCaptionFont("This Action can not be undone.", invert: true),
        const SizedBox(height: kDefaultPadding),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: NButton(
            "Delete",
            tooltip: "Delete Entry",
            width: 250.0,
            invert: true,
            onPressed: () {
              widget.delete(true);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
