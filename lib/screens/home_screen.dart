import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:nucleon/nucleon.dart';

import 'package:journal/data.dart';
import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/widgets/journal_entry_card.dart';
import 'package:journal/widgets/utils/j_screen.dart';
import 'package:journal/widgets/pages/home_blank_page.dart';
import 'package:journal/widgets/dialog/add_entry_dialog.dart';
import 'package:journal/widgets/pages/journal_entry_content_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Core _core;
  late List<JournalEntry> entries;

  JournalEntry? selectedEntry;

  bool isEntrySelected(JournalEntry entry) {
    if (selectedEntry == null) return false;
    return selectedEntry == entry;
  }

  void selectEntry(JournalEntry entry) {
    if (selectedEntry != null && selectedEntry == entry) {
      selectedEntry = null;
      return;
    }
    selectedEntry = entry;
  }

  void getEntries() {
    entries = _core.journalService.journalEntryList;
  }

  Widget journalEntriesSection() {
    // TODO search bar
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 3 - kWindowRadius,
      child: Padding(
        padding: const EdgeInsets.only(right: kDefaultPadding),
        child: NScrollFade(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          child: ListView(
            children: [
              for (int i = 0; i < entries.length; i++)
                JournalEntryCard(
                      journalEntry: entries[i],
                      selected: isEntrySelected(entries[i]),
                      onTap: () => setState(() => selectEntry(entries[i])),
                    )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 100 * i),
                      curve: Curves.fastEaseInToSlowEaseOut,
                    )
                    .slideX(
                      delay: Duration(milliseconds: 100 * i),
                      curve: Curves.decelerate,
                    ),
              const SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget journalEntryDetailSection() {
    return Row(
      children: [
        // Border
        Container(width: 1.0, color: Theme.of(context).focusColor),
        // Content
        SizedBox(
          width:
              (MediaQuery.sizeOf(context).width * 2 / 3) - kWindowRadius - 1.0,

          child: selectedEntry == null
              ? HomeBlankPage()
              : JournalEntryContentPage(
                  entry: selectedEntry!,
                  afterEntryRemoved: () {
                    getEntries();
                    setState(() => selectedEntry = null);
                  },
                ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _core = CoreManager.instance.core;
    getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return JScreen(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nShowDialog(
            context: context,
            dialog: AddEntryDialog(),
            after: () => setState(() => getEntries()),
          );
        },
        backgroundColor: Theme.of(context).focusColor,
        hoverColor: Theme.of(context).focusColor,
        child: Center(
          child: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height - 3 * kWindowRadius,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [journalEntriesSection(), journalEntryDetailSection()],
        ),
      ),
    );
  }
}
