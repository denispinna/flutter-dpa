import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/productivity.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/widget/chart/bar_chart_screen.dart';
import 'package:dpa/widget/chart/donut_chart_screen.dart';
import 'package:dpa/widget/chart/stack_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return StatEntry(
        id: this.documentID, date: date.toDate(), elements: elements);
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
  List<DonutGraphData> toDonutGraphData(StatItem item) {
    Map<dynamic, DonutGraphData> data = Map();
    final key = item.key;
    int total = 0;

    for (final entry in this) {
      final value = entry.elements[key].round().toDouble();
      if (value != null) {
        total++;
        (data[value] == null)
            ? data[value] = DonutGraphData(
                label: _getLabel(key, value),
                occurrences: 1,
                value: value,
                color: _getColor(key, value))
            : data[value].occurrences += 1;
      }
    }
    final list = data.values.toList();
    list.sort((a, b) => a.value.compareTo(b.value));
    for (final entry in list) {
      entry.percentage = entry.occurrences / total;
    }
    return list;
  }

  static const MAX_LINE_CHART_ENTRIES = 10.0;

  List<BarGraphData> toBarGraphData(StatItem item) {
    List<BarGraphData> data = List();
    this.sort((a, b) => a.date.compareTo(b.date));
    final key = item.key;

    for (final entry in this) {
      final value = entry.elements[key];
      if (value != null) {
        data.add(BarGraphData(
          startDate: entry.date,
          endDate: entry.date,
          value: value,
        ));
      }
    }

    if (data.length > MAX_LINE_CHART_ENTRIES) {
      List<BarGraphData> avgData = List();
      final groupSize =
          (data.length.toDouble() / MAX_LINE_CHART_ENTRIES).ceil();
      for (var i = 0; i < data.length; i++) {
        double currentGroupSize = 0;
        double currentGroupValue = 0;
        DateTime startDate = this[i].date;
        DateTime endDate = this[i].date;
        for (var j = 0; j < groupSize; j++) {
          if (i < data.length) {
            currentGroupSize++;
            currentGroupValue += data[i].value;
            endDate = data[i].startDate;
          }
          i++;
        }
        if (currentGroupSize > 0)
          avgData.add(BarGraphData(
            value: currentGroupValue / currentGroupSize,
            startDate: startDate,
            endDate: endDate,
          ));
      }
      data = avgData;
    }

    for (final item in data) {
      item.color = _getColor(key, item.value.toInt());
    }
    return data;
  }

  //TODO: improve division
  static const STACKED_CHART_COLUMN_NUMBER = [3, 4, 5, 6];

  int getBestColumnNumber(int count) {
    int best = STACKED_CHART_COLUMN_NUMBER[0];
    double lastDiff = count.toDouble();

    for (final number in STACKED_CHART_COLUMN_NUMBER) {
      int byColumn = (count / (number)).floor();
      int remainder = count % byColumn;
      double diff = remainder / number;
      if (diff <= lastDiff) {
        lastDiff = diff;
        best = number;
      }
    }
    return best;
  }

  List<List<StackedBarGraphData>> toStackedBarGraphData(StatItem item) {
    final key = item.key;
    this.sort((a, b) => a.date.compareTo(b.date));
    int days = this.first.date.difference(this.last.date).inDays.abs();
    int columnNumber = getBestColumnNumber(days);
    int daysByColumn = (days / columnNumber).round();
    Set<int> values = Set();
    DateTime before = DateTime(
        this.first.date.year, this.first.date.month, this.first.date.day);

    Map<String, Map<int, int>> occurrencesByColumn = Map();

    for (var i = 0; i < columnNumber; i++) {
      DateTime after = before;
      before = before.add(Duration(days: daysByColumn));
      final column = List<StatEntry>.from(this);
      column.retainWhere(
          (entry) => entry.date.isBefore(before) && entry.date.isAfter(after));

      DateTime startDate = column.first.date;
      DateTime endDate = column.last.date;
      String label =
          "${DateFormat("d MMM").format(startDate)}\n${DateFormat("d MMM").format(endDate)}";
      Map<int, int> occurrences = Map();
      for (final entry in column) {
        final value = entry.elements[key].round();
        if (value != null) {
          occurrences[value] =
              (occurrences[value] == null) ? 1 : occurrences[value] + 1;
          values.add(value);
        }
      }
      occurrencesByColumn[label] = occurrences;
    }

    List<List<StackedBarGraphData>> data = List();
    for (final value in values) {
      List<StackedBarGraphData> columnData = List();
      for (final key in occurrencesByColumn.keys) {
        columnData.add(StackedBarGraphData(
            label: key,
            occurrences: occurrencesByColumn[key][value],
            value: value));
      }
      data.add(columnData);
    }

    for (final column in data) {
      for (final item in column) item.color = _getColor(key, item.value);
    }

    data.sort((a, b) => b.first.value.compareTo(a.first.value));
    return data;
  }
}

String _getLabel(String itemKey, num value) {
  if (itemKey == DefaultStatItem.default_mood.label) {
    return Mood.values[value.toInt() - 1].getLabel().toUpperCase();
  } else if (itemKey == DefaultStatItem.default_productivity.label) {
    return (value as double).getProductivityLabel().toUpperCase();
  } else
    return value.toString();
}

Color _getColor(String itemKey, num value) {
  if (itemKey == DefaultStatItem.default_mood.label) {
    return Mood.values[value.toInt() - 1].color;
  } else if (itemKey == DefaultStatItem.default_productivity.label) {
    return value.toDouble().productivityColor;
  } else
    return null;
}
