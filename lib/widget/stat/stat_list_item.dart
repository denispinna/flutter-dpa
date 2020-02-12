import 'package:dpa/models/mood.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/widget/stat/date_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StatListWidget extends StatefulWidget {
  final StatEntry statEntry;
  final Map<String, StatItem> statItems;

  const StatListWidget({@required this.statEntry, @required this.statItems});

  @override
  _StatListWidgetState createState() => _StatListWidgetState();
}

class _StatListWidgetState extends State<StatListWidget> {
  List<Widget> collapsedWidgets = List();
  List<Widget> expandedWidgets = List();
  List<MapEntry<StatItem, dynamic>> orderedStatEntries = List();

  @override
  void initState() {
    super.initState();
    for (final entry in widget.statEntry.elements.entries) {
      final item = widget.statItems[entry.key];
      orderedStatEntries.add(MapEntry(item, entry.value));
    }

    orderedStatEntries.sort((a, b) => a.key.position.compareTo(b.key.position));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.statEntry.expanded)
      content = buildExpandedTile(context);
    else
      content = buildCollapsedTile(context);

    return GestureDetector(
      onTap: () {
        toggleExpand();
      },
      child: content,
    );
  }

  Widget buildExpandedTile(BuildContext context) {
    if (expandedWidgets.length == 0) setupExpandedWidgets();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.s),
        child: Column(
          children: expandedWidgets,
        ),
      ),
    );
  }

  Widget buildCollapsedTile(BuildContext context) {
    Mood mood = Mood.values[widget.statEntry.mood.toInt() - 1];
    if (collapsedWidgets.length == 0) setupCollapsedWidgets();

    return Card(
      elevation: Dimens.xxxxs,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.s,
          horizontal: Dimens.s,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.xs,
              ),
              child: mood.icon,
            ),
            Container(width: Dimens.s),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: collapsedWidgets,
            ),
          ],
        ),
      ),
    );
  }

  void toggleExpand() {
    widget.statEntry.expanded = !widget.statEntry.expanded;
    setState(() {});
  }

  void setupCollapsedWidgets() {
    collapsedWidgets.add(DateTitle(date: widget.statEntry.date));
    for (final entry in orderedStatEntries) {
      if (entry.key != null && entry.key.displayInList) {
        collapsedWidgets.add(SizedBox(height: Dimens.xxxxs));
        collapsedWidgets.add(entry.key
            .getOutputListWidget(context: context, value: entry.value));
      }
    }
  }

  void setupExpandedWidgets() {
    expandedWidgets.add(DateTitle(
      date: widget.statEntry.date,
      fontSize: Dimens.m,
    ));
    for (final entry in orderedStatEntries) {
      if (entry.key != null) {
        expandedWidgets.add(SizedBox(height: Dimens.s));
        expandedWidgets.add(entry.key
            .getOutputDetailWidget(context: context, value: entry.value));
      }
    }
  }
}
