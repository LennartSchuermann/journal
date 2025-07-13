import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:nucleon/nucleon.dart';
import 'package:nucleon/nucleon_widgets.dart';

import 'package:journal/core/core.dart';
import 'package:journal/core/core_manager.dart';
import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/widgets/dialog/deletion_dialog.dart';
import 'package:journal/widgets/utils/markdown_math.dart';

class JournalEntryContentPage extends StatefulWidget {
  const JournalEntryContentPage({
    super.key,
    required this.entry,
    required this.afterEntryRemoved,
  });

  final JournalEntry entry;
  final Function afterEntryRemoved;

  @override
  State<JournalEntryContentPage> createState() =>
      _JournalEntryContentPageState();
}

class _JournalEntryContentPageState extends State<JournalEntryContentPage> {
  bool inEditMode = false;

  late TextEditingController textEditingController;

  late Core core;
  late JournalEntry currentEntry;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    core = CoreManager.instance.core;
    currentEntry = widget.entry;
  }

  @override
  void dispose() {
    super.dispose();

    textEditingController.dispose();
  }

  void resetPage() {
    currentEntry =
        core.journalService.getEntry(entryDate: widget.entry.dateTime) ??
        widget.entry;

    if (!inEditMode) return;

    setState(() {
      textEditingController.text = currentEntry.journalContent;
    });
  }

  Future saveEdit() async {
    JournalEntry updatedEntry = JournalEntry.from(
      entry: currentEntry,
      contentOverride: textEditingController.text,
    );
    core.journalService.updateEntry(entryToUpdate: updatedEntry);

    bool hasChanges =
        (currentEntry.journalContent != updatedEntry.journalContent);

    currentEntry = updatedEntry;
    if (hasChanges) core.setUnsavedChanges();
  }

  bool deleteEntry() {
    return core.journalService.removeEntry(removeAtDate: currentEntry.dateTime);
  }

  Widget toolBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 128.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          border: BoxBorder.all(color: Theme.of(context).focusColor),
        ),

        child: Padding(
          padding: const EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    bool delete = false;
                    nShowDialog(
                      context: context,
                      dialog: DeletionDialog(
                        entry: currentEntry,
                        delete: (deleteEntry) {
                          delete = deleteEntry;
                        },
                      ),
                      after: () {
                        if (!delete) return;

                        deleteEntry();
                        core.setUnsavedChanges();
                        widget.afterEntryRemoved();
                      },
                    );
                  },
                  child: Icon(
                    FeatherIcons.trash2,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    if (inEditMode) await saveEdit();

                    setState(() => inEditMode = !inEditMode);
                  },
                  child: Icon(
                    inEditMode ? FeatherIcons.check : FeatherIcons.edit2,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget journalContent() {
    return Column(
      children: [
        //Header
        Row(
          children: [
            NSubheadingFont(
              getFormattedDate(
                currentEntry.dateTime.toLocal(),
                useDateOnly: false,
              ),
              dekstopFS: true,
            ),
          ],
        ),
        const SizedBox(height: kDefaultPadding),

        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: inEditMode
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: BoxBorder.all(color: Theme.of(context).focusColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: textEditingController,
                      minLines: 1,
                      maxLines: 28,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Theme.of(context).focusColor,
                      style: nContentFontTextStyle(
                        context: context,
                        invert: false,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                )
              : NScrollFade(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  child: MarkdownWidget(
                    data: currentEntry.journalContent,
                    selectable: false,
                    markdownGenerator: MarkdownGenerator(
                      generators: [latexGenerator],
                      inlineSyntaxList: [LatexSyntax()],
                      richTextBuilder: (span) => Text.rich(span),
                    ),
                    config: MarkdownConfig(
                      // TODO fix todo lists... padding??? & create config
                      configs: [
                        TableConfig(), // TODO Table Config ?
                        ListConfig(),
                        HrConfig(color: Theme.of(context).focusColor),
                        H1Config(style: nBrandFontTextStyle(context: context)),
                        H2Config(
                          style: nTitleFontTextStyle(
                            context: context,
                            invert: false,
                          ),
                        ),
                        H3Config(
                          style: nSubheadingFontTextStyle(
                            context: context,
                            invert: false,
                          ),
                        ),
                        LinkConfig(
                          style: nContentFontTextStyle(
                            context: context,
                            color: NColorPalette.electonBlue.getColor(),
                            invert: false,
                          ),
                          onTap: (url) async {
                            await Clipboard.setData(ClipboardData(text: url));

                            if (mounted) {
                              nShowToast(
                                context,
                                title: "Copied Link to Clipboard",
                                description: "",
                                type: ToastType.alert,
                                widthOverride:
                                    MediaQuery.sizeOf(context).width / 4.0,
                              );
                            }
                          },
                        ),
                        PConfig(
                          textStyle: nContentFontTextStyle(
                            context: context,
                            invert: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          // Old, none Markdown Display
          /* NScrollFade(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  child: ListView(
                    children: [
                       NContentFont(
                        currentEntry.journalContent,
                        hideOverflow: false,
                      ), 
                      

                      const SizedBox(height: kDefaultPadding * 1.5),
                    ],
                  ),
                ),*/
        ),
        // Content
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    resetPage();

    return Padding(
      padding: const EdgeInsets.only(left: kDefaultPadding),
      child: Stack(children: [journalContent(), toolBar()]),
    );
  }
}
