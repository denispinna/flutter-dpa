import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/services/auth_services.dart';

extension StatEntryExt on StatEntry {
  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      _Fields.date.label: date,
      _Fields.userEmail.label: AuthAPI.instance.user.email,
      _Fields.stats.label: stats
    };
  }
}

extension ParseDocToStat on DocumentSnapshot {
  StatEntry toStatEntry() {
    Map<String, dynamic> data = this.data;
    final date = data[_Fields.date.label] as Timestamp;
    final stats = HashMap<String, dynamic>();
    for(final statEntry in data[_Fields.stats.label].entries){
      stats[statEntry.key] = statEntry.value;
    }
    return StatEntry(
      id: this.documentID,
      date: date.toDate(),
      stats: stats
    );
  }
}

enum _Fields {
  date,
  userEmail,
  stats,
}

extension _FieldExt on _Fields {
  String get label => this.toString().split(".")[1];
}

List<StatEntry> parseStatEntries(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return document.toStatEntry();
  }).toList();
}
