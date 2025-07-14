import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/data.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/widgets/dialog/deletion_dialog.dart';

class JournalContentPageController {
  late Core _core;

  late JournalEntry _currentEntry;
  late JournalEntry _entry;

  bool inEditMode = false;
  late TextEditingController textEditingController;

  JournalEntry get currentEntry => _currentEntry;

  // TODO disable edit mode on entry change

  JournalContentPageController({required JournalEntry entry}) {
    _core = CoreManager.instance.core;

    _entry = entry;
    _currentEntry = entry;

    textEditingController = TextEditingController();
  }

  void dispose() {
    textEditingController.dispose();
  }

  void resetPage({required JournalEntry prevEntry}) {
    _currentEntry =
        _core.journalService.getEntry(entryDate: prevEntry.dateTime) ?? _entry;

    if (!inEditMode) return;

    textEditingController.text = _currentEntry.journalContent;
  }

  Future saveEdit() async {
    JournalEntry updatedEntry = JournalEntry.from(
      entry: _currentEntry,
      contentOverride: textEditingController.text,
    );
    _core.journalService.updateEntry(entryToUpdate: updatedEntry);

    bool hasChanges =
        (_currentEntry.journalContent != updatedEntry.journalContent);

    _currentEntry = updatedEntry;
    if (hasChanges) _core.setUnsavedChanges();
  }

  Future editMode() async {
    if (inEditMode) await saveEdit();
    inEditMode = !inEditMode;
  }

  void deleteEntry({
    required BuildContext context,
    required Function afterEntryRemoved,
  }) {
    bool delete = false;
    nShowDialog(
      context: context,
      dialog: DeletionDialog(
        entry: _currentEntry,
        delete: (deleteEntry) {
          delete = deleteEntry;
        },
      ),
      after: () {
        if (!delete) return;

        _core.journalService.removeEntry(removeAtDate: _currentEntry.dateTime);
        _core.setUnsavedChanges();
        afterEntryRemoved();
      },
    );
  }

  Future copyLink({required BuildContext context, required String url}) async {
    await Clipboard.setData(ClipboardData(text: url));

    if (context.mounted) {
      nShowToast(
        context,
        title: "Copied Link to Clipboard",
        description: "",
        type: ToastType.alert,
        widthOverride: getToastWidth(context),
      );
    }
  }
}
