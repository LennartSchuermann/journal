import 'package:flutter/material.dart';
import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

class JournalEntryCard extends StatefulWidget {
  const JournalEntryCard({
    super.key,
    required this.journalEntry,
    required this.selected,
    required this.onTap,
  });

  final JournalEntry journalEntry;
  final bool selected;
  final Function() onTap;

  @override
  State<JournalEntryCard> createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: NCard(
          width: 347.0,
          height: 75.0,
          borderRadius: 20.0,
          border: BoxBorder.all(color: Theme.of(context).focusColor),
          cardColor: !widget.selected ? Colors.transparent : null,
          onPressed: widget.onTap,
          child: Row(
            children: [
              NTitleFont(
                getFormattedDate(widget.journalEntry.dateTime.toLocal()),
                invert: widget.selected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
