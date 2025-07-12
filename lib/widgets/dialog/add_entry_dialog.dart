import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/core/utils/date_utils.dart';
import 'package:journal/data.dart';
import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({super.key});

  @override
  State<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  late Core core;
  late DateTime newEntryDate;

  bool entryExists = false;

  @override
  void initState() {
    super.initState();

    core = CoreManager.instance.core;
    newEntryDate = DateTime.now();

    entryExists = doesEntryExist();
  }

  bool doesEntryExist() {
    return core.journalService.journaltrack.containsEntry(
      dateOnly(newEntryDate),
    );
  }

  void addEntry() {
    JournalEntry newEntry = JournalEntry(dateTime: dateOnly(newEntryDate));

    core.journalService.updateEntry(entryToUpdate: newEntry);
    core.setUnsavedChanges();
  }

  @override
  Widget build(BuildContext context) {
    return NPopUpDialog(
      title: "${entryExists ? "Override" : "Add"} Journal Entry",
      invert: true,
      maxWidth: MediaQuery.sizeOf(context).width / 2.0,
      content: [
        NModalDatePicker(
          invert: true,
          minDate: kMinDateTime,
          maxDate: DateTime.now(),
          initDate: newEntryDate,
          onDateChanged: (dt) => setState(() {
            newEntryDate = dt;
            entryExists = doesEntryExist();
          }),
          onClose: (dt) => setState(() {
            newEntryDate = dt;
            entryExists = doesEntryExist();
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding / 2),
          child: entryExists
              ? NContentFont(
                  "Entry for this Date already exists. You have to delete the Entry first, which can not be undone!",
                  invert: true,
                )
              : const SizedBox(),
        ),
        !entryExists
            ? Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: NIconCircle(
                  iconData: FeatherIcons.check,
                  invertColors: true,
                  tooltip: "${entryExists ? "Override" : "Add"} Entry",
                  onPressed: () {
                    addEntry();
                    Navigator.pop(context);
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
