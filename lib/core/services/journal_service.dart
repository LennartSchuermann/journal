import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/core/classes/journal/journal_track.dart';

class JournalService {
  late Journaltrack _journaltrack;

  Journaltrack get journaltrack =>
      _journaltrack; // TODO remove... to use the service only...

  JournalService({required Journaltrack journaltrack}) {
    _journaltrack = journaltrack;
  }

  void updateEntry({required JournalEntry entryToUpdate}) =>
      _journaltrack.updateTrackEntry(entryToUpdate);

  bool removeEntry({required DateTime removeAtDate}) =>
      _journaltrack.removeEntry(removeAtDate);
}
