import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/stat_entry.dart';

extension StatEntryExt on StatEntry {
  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      _Fields.date.label: date,
      _Fields.userEmail.label: userEmail,
      _Fields.stats.label: stats
    };
  }
}

extension ParseDocToStat on DocumentSnapshot {
  StatEntry toStatEntry() {
    Map<String, dynamic> data = this.data;
    final date = data[_Fields.date.label] as Timestamp;
    final userEmail = data[_Fields.userEmail.label];
    final stats = data[_Fields.stats.label];
    return StatEntry(
        id: this.documentID, date: date.toDate(), userEmail: userEmail);
  }
}

enum _Fields {
  date,
  userEmail,
  stats,
}

extension _FieldExt on _Fields {
  String get label => this.toString();
}


List<StatEntry> parseStatEntries(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return document.toStatEntry();
  }).toList();
}
