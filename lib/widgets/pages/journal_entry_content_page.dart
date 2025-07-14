import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:journal/data.dart';
import 'package:journal/widgets/pages/controller/journal_content_page_controller.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:nucleon/nucleon.dart';

import 'package:journal/core/classes/journal/journal_entry.dart';
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
  late JournalContentPageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = JournalContentPageController(entry: widget.entry);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void resetPage() {
    pageController.resetPage(prevEntry: widget.entry);
    setState(() {});
  }

  Future editMode() async {
    await pageController.editMode().then((val) => setState(() {}));
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
                  onTap: () => pageController.deleteEntry(
                    context: context,
                    afterEntryRemoved: () => widget.afterEntryRemoved(),
                  ),
                  child: Icon(
                    FeatherIcons.trash2,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async => await editMode(),
                  child: Icon(
                    pageController.inEditMode
                        ? FeatherIcons.check
                        : FeatherIcons.edit2,
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
                pageController.currentEntry.dateTime.toLocal(),
                useDateOnly: false,
              ),
              dekstopFS: true,
            ),
          ],
        ),
        const SizedBox(height: kDefaultPadding),

        // Content (EditMode / ReadMode)
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: pageController.inEditMode
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: BoxBorder.all(color: Theme.of(context).focusColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: pageController.textEditingController,
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
                    data: pageController.currentEntry.journalContent,
                    selectable: false,
                    markdownGenerator: MarkdownGenerator(
                      generators: [latexGenerator],
                      inlineSyntaxList: [LatexSyntax()],
                      richTextBuilder: (span) => Text.rich(span),
                    ),
                    config: markdownConfig(
                      context: context,
                      onLinkTap: (url) async => await pageController.copyLink(
                        context: context,
                        url: url,
                      ),
                    ),
                  ),
                ),
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
      child: Stack(
        children: [
          journalContent(),
          toolBar().animate().fadeIn(
            delay: Duration(milliseconds: 200),
            duration: Duration(milliseconds: 200),
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
          //.slideY(curve: Curves.fastEaseInToSlowEaseOut),
        ],
      ),
    );
  }
}
