import 'dart:collection';

import 'package:collection/collection.dart';

import 'package:journal/core/classes/journal/journal_entry.dart';
import 'package:journal/core/utils/date_utils.dart';

class Journaltrack {
  /// Internal Set storing Entries sorted by Date in utc format
  final SplayTreeSet<JournalEntry> entries = SplayTreeSet(
    (a, b) => a.compareTo(b), // sort oldest to newest
  );

  JournalEntry? get latestEntry => entries.lastOrNull;
  JournalEntry? get oldestEntry => entries.firstOrNull;

  Set<JournalEntry> get journalEntries => Set.unmodifiable(entries);
  List<JournalEntry> get journalEntryList =>
      List.unmodifiable(entries.toList().reversed);

  bool get hasEntries => entries.isNotEmpty;

  Journaltrack();

  /// gets Entry by date if exists using utc time [date].
  JournalEntry? getEntry(DateTime date) {
    return entries.firstWhereOrNull((e) => e.dateTime.isAtSameMomentAs(date));
  }

  /// Adds or updates an entry
  void updateTrackEntry(JournalEntry entry) {
    if (entry.dateTime.isAfter(dateOnly(DateTime.now()))) {
      throw ArgumentError("Cannot track for a future date.");
    }

    final JournalEntry? exEntry = getEntry(dateOnly(entry.dateTime));
    if (exEntry != null) entries.remove(exEntry); // remove old

    // add (updated)
    entries.add(entry);
  }

  /// return true if entry with [entryDate] (in utc time zone) exists
  bool containsEntry(DateTime entryDate) {
    return getEntry(entryDate) != null;
  }

  /// Removes an entry using local [date]. Returns true if entry found & removed
  bool removeEntry(DateTime date) {
    // search for entry
    final match = entries.where((e) => dateOnly(e.dateTime) == dateOnly(date));
    JournalEntry? existing = match.isNotEmpty ? match.first : null;

    return entries.remove(existing);
  }

  /// use local timezones for [start] and [end]
  Iterable<JournalEntry> getEntriesInRange(DateTime from, DateTime to) sync* {
    // normalize to utc
    final DateTime start = dateOnly(from);
    final DateTime end = dateOnly(from);

    for (final entry in entries) {
      if (entry.dateTime.isBefore(start)) continue;
      if (entry.dateTime.isAfter(end)) break;
      yield entry;
    }
  }

  /// Convert to JSON (as List)
  Map<String, dynamic> toJson() => {
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  /// Create from JSON
  factory Journaltrack.fromJson(Map<String, dynamic> json) {
    final track = Journaltrack();
    final entriesList = json['entries'] as List<dynamic>;

    for (var item in entriesList) {
      track.entries.add(JournalEntry.fromJson(item));
    }

    return track;
  }
}
