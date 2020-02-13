import 'package:dpa/components/logger.dart';
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
  List<StatItem> statItems;
  DateTime startDate;
  DateTime endDate;
  ChartWidget chartWidget;

  @override
  void initState() {
    DateTime now = DateTime.now();
    startDate = DateTime(now.year, now.month - 1, now.day);
    endDate = now;
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          DateRangePicker(
            startDateSelected: startDate,
            endDateSelected: endDate,
            onStartDateChanged: (date) {
              this.startDate = date;
              load(showLoading: false);
            },
            onEndDateChanged: (date) {
              this.endDate = date;
              load(showLoading: false);
            },
          ),
          Expanded(
            child: chartWidget,
          ),
        ],
      ),
    );
  }

  @override
  Future loadFunction() async {
    if (statItems == null) {
      final snapshot = await API.statApi.getEnabledStatItems().getDocuments();
      this.statItems = await compute(parseStatItems, snapshot.documents);
    }
    chartWidget = ChartWidget(
      statItems: statItems,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class ChartWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<StatItem> statItems;

  const ChartWidget({
    @required this.statItems,
    @required this.startDate,
    @required this.endDate,
  });

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends StateWithLoading<ChartWidget> {
  Widget chartWidget;
  List<StatEntry> entries;
  DateTime lastStartDate;
  DateTime lastEndDate;

  @override
  Widget buildWidget(BuildContext context) {
    if(shouldLoad()) {
      load();
      return buildLoadingWidget(context);
    }
    Logger.log(runtimeType.toString(),
        '$this built with ${widget.startDate} - ${widget.endDate}');
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 400.0),
      child: chartWidget,
    );
  }

  @override
  Color get backgroundColor => null;

  @override
  bool shouldLoad() =>
      entries == null ||
      lastStartDate != widget.startDate ||
      lastEndDate != widget.endDate;

  @override
  Future loadFunction() async {
    if (chartWidget != null && !shouldLoad()) return;
    var snapshot = await API.statApi
        .getStats(from: widget.startDate, to: widget.endDate)
        .getDocuments();
    final entries = await compute(parseStatEntries, snapshot.documents);
    this.entries = entries;
    Logger.log(runtimeType.toString(),
        '${entries.length} entries loaded for the chart.');
    if (entries == null || entries.length == 0)
      chartWidget = Container();
    else
      chartWidget = DonutChart.generate(entries, widget.statItems[1], context);
    lastStartDate = widget.startDate;
    lastEndDate = widget.endDate;
  }
}
