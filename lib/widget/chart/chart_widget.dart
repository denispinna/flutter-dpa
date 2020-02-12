import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/stat_item_parser.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/chart/donut_chart.dart';
import 'package:dpa/widget/date/date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalChartsScreen extends StatefulWidget {
  @override
  _GlobalChartsScreenState createState() => _GlobalChartsScreenState();
}

class _GlobalChartsScreenState extends StateWithLoading<GlobalChartsScreen> {
  DateTime startDate;
  DateTime endDate;
  ChartWidget chartWidget;

  @override
  void initState() {
    DateTime now = DateTime(2020, 1, 13);
    startDate = DateTime(now.year, now.month - 1, now.day);
    endDate = now;
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DateRangePicker(
            startDateSelected: startDate,
            endDateSelected: endDate,
            onStartDateChanged: (date) {
              this.startDate = date;
              load(showLoading: true);
            },
            onEndDateChanged: (date) {
              this.endDate = date;
              load(showLoading: true);
            },
          ),
          chartWidget,
        ],
      ),
    );
  }

  @override
  Future loadFunction() async {
    var snapshot =
        await API.statApi.getStats(from: startDate, to: endDate).getDocuments();
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
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 400.0),
      child: DonutChart.generate(entries, statItems[1], context),
    );
  }
}
