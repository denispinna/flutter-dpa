import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/productivity.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/widget/chart/donut_chart.dart';
import 'package:flutter/material.dart';

extension StatEntryExt on StatEntry {
  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      StatEntryFields.date.label: date,
      StatEntryFields.userEmail.label: AuthAPI.instance.user.email,
      StatEntryFields.elements.label: elements
    };
  }
}

extension ParseDocToStat on DocumentSnapshot {
  StatEntry toStatEntry() {
    Map<String, dynamic> data = this.data;
    final date = data[StatEntryFields.date.label] as Timestamp;
    final elements = HashMap<String, dynamic>();
    for (final statEntry in data[StatEntryFields.elements.label].entries) {
      elements[statEntry.key] = statEntry.value;
    }
    return StatEntry(id: this.documentID, date: date.toDate(), elements: elements);
  }
}

enum StatEntryFields {
  date,
  userEmail,
  elements,
}

extension StatEntryFieldExt on StatEntryFields {
  String get label => this.toString().split(".")[1];
}

List<StatEntry> parseStatEntries(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return document.toStatEntry();
  }).toList();
}

extension GraphExt on List<StatEntry> {
  List<DonutGraphData> toDonutGraphData(StatItem item, BuildContext context) {
    Map<dynamic, DonutGraphData> data = Map();
    final key = item.key;
    int total = 0;

    for (final entry in this) {
      final value = entry.elements[key].round().toDouble();
      if (value != null) {
        total++;
        (data[value] == null)
            ? data[value] = DonutGraphData(
                label: _getLabel(key, value, context),
                occurrences: 1,
                value: value,
                color: _getColor(key, value))
            : data[value].occurrences += 1;
      }
    }
    final list = data.values.toList();
    list.sort((a,b) => a.value.compareTo(b.value));
    for(final entry in list) {
      entry.percentage = entry.occurrences/total;
    }
    return list;
  }
}

String _getLabel(String itemKey, dynamic value, BuildContext context) {
  if (itemKey == DefaultStatItem.default_mood.label) {
    return Mood.values[value.toInt() - 1].getLabel(context).toUpperCase();
  } else if (itemKey == DefaultStatItem.default_productivity.label) {
    return (value as double).getProductivityLabel(context).toUpperCase();
  } else
    return value.toString();
}

Color _getColor(String itemKey, dynamic value) {
  if (itemKey == DefaultStatItem.default_mood.label) {
    return Mood.values[value.toInt() - 1].color;
  } else if (itemKey == DefaultStatItem.default_productivity.label) {
    return (value as double).productivityColor;
  } else
    return null;
}
