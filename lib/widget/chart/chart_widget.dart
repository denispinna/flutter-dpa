import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/stat_item_parser.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/chart/donut_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalChartsScreen extends StatefulWidget {
  @override
  _GlobalChartsScreenState createState() => _GlobalChartsScreenState();
}

class _GlobalChartsScreenState extends StateWithLoading<GlobalChartsScreen> {
  ChartWidget chartWidget;

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: chartWidget,
    );
  }

  @override
  Future loadFunction() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year - 1, now.month, 1);
    var snapshot = await API.statApi
        .getStats(from: firstDayOfMonth, to: now)
        .getDocuments();
    final entries = await compute(parseStatEntries, snapshot.documents);
    snapshot = await API.statApi.getEnabledStatItems().getDocuments();
    final statItems = await compute(parseStatItems, snapshot.documents);
    chartWidget = ChartWidget(
      entries: entries,
      statItems: statItems,
    );
  }
}

class ChartWidget extends StatelessWidget {
  final List<StatEntry> entries;
  final List<StatItem> statItems;

  const ChartWidget({
    @required this.entries,
    @required this.statItems,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DonutChart.generate(entries, statItems[1], context),
    );
  }
}
