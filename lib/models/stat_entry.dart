import 'dart:collection';

import 'package:flutter/cupertino.dart';

class StatEntry {
  final String id;
  final HashMap<String, dynamic> elements;
  DateTime date;
  bool expanded;

  StatEntry({
    @required DateTime date,
    @required this.elements,
    this.expanded = false,
    this.id = "",
  }) {
    this.date = date != null ? date : DateTime.now();
  }
}
