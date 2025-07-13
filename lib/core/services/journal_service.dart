import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/core/classes/journal/journal_track.dart';

class JournalService {
  late Journaltrack _journaltrack;

  JournalService({required Journaltrack journaltrack}) {
    _journaltrack = journaltrack;
  }

  List<JournalEntry> get journalEntryList => _journaltrack.journalEntryList;

  void updateEntry({required JournalEntry entryToUpdate}) =>
      _journaltrack.updateTrackEntry(entryToUpdate);

  bool removeEntry({required DateTime removeAtDate}) =>
      _journaltrack.removeEntry(removeAtDate);

  bool containsEntry({required DateTime entryDate}) =>
      _journaltrack.containsEntry(entryDate);

  JournalEntry? getEntry({required DateTime entryDate}) =>
      _journaltrack.getEntry(entryDate);
}
