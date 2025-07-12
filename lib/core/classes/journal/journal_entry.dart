class JournalEntry implements Comparable<JournalEntry> {
  // Journal Date in utc-Format
  final DateTime dateTime;
  final String journalContent;

  const JournalEntry({required this.dateTime, this.journalContent = ""});

  JournalEntry.from({required JournalEntry entry, String? contentOverride})
    : dateTime = entry.dateTime,
      journalContent = contentOverride ?? entry.journalContent;

  @override
  int compareTo(JournalEntry other) => dateTime.compareTo(other.dateTime);

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'dateTime': dateTime.toIso8601String(),
    'journalContent': journalContent,
  };

  /// Create from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      dateTime: DateTime.parse(json['dateTime']),
      journalContent: json['journalContent'] ?? "",
    );
  }
}
