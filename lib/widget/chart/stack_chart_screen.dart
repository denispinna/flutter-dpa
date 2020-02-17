import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/base/persistent_widget.dart';
import 'package:dpa/widget/chart/stack_chart.dart';
import 'package:dpa/widget/date/date_range_picker.dart';
import 'package:dpa/widget/stat/stat_item_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux/src/store.dart';

class StackedBarChartsScreen extends StatefulWidget {
  @override
  _StackedBarChartsScreenState createState() => _StackedBarChartsScreenState();
}

class _StackedBarChartsScreenState
    extends StoreConnectedState<StackedBarChartsScreen, List<StatItem>> {
  DateTime startDate;
  DateTime endDate;
  StatItem statItem;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    startDate = DateTime(now.year, now.month - 1, now.day);
    endDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget buildWithStore(BuildContext context, List<StatItem> statItems) {
    if (statItem == null) statItem = statItems[0];
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          DateRangePicker(
            startDateSelected: startDate,
            endDateSelected: endDate,
            onStartDateChanged: (date) {
              startDate = date;
              setState(() {});
            },
            onEndDateChanged: (date) {
              endDate = date;
              setState(() {});
            },
          ),
          StatItemPicker(
            statItems: statItems,
            selected: statItem,
            onItemSelected: (item) {
              statItem = item;
              setState(() {});
            },
          ),
          Expanded(
            child: ChartWidget(
              statItem: statItem,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        ],
      ),
    );
  }

  @override
  List<StatItem> converter(Store store) {
    /* Here, we want to keep only the kind of item that makes sense with this chart */
    List<StatItem> filtered = List();
    filtered.addAll(store.state.statItems);
    filtered.retainWhere(
            (element) => element is QuantityStatItem || element is McqStatItem);
    return filtered;
  }
}

class ChartWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final StatItem statItem;

  const ChartWidget({
    @required this.statItem,
    @required this.startDate,
    @required this.endDate,
  });

  @override
  _StackedBarChartWidgetState createState() => _StackedBarChartWidgetState();
}

class _StackedBarChartWidgetState extends StateWithLoading<ChartWidget>
    with Persistent<_ChartWidgetStateContent> {

  @override
  void initState() {
    recoverContent(context: context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    persistOrRecoverContent(context: context);
    return super.build(context);
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (shouldLoad()) {
      load();
      return buildLoadingWidget(context);
    }

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 400.0),
      child: content.chartWidget,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Color get backgroundColor => null;

  @override
  bool shouldLoad() =>
      content.chartWidget == null ||
          content.entries == null ||
          content.lastStatItem != widget.statItem ||
          content.lastStartDate != widget.startDate ||
          content.lastEndDate != widget.endDate;

  @override
  Future loadFunction() async {
    if (!shouldLoad()) return;

    if (content.lastStartDate != widget.startDate ||
        content.lastEndDate != widget.endDate) {
      final snapshot = await API.statApi
          .getStats(from: widget.startDate, to: widget.endDate)
          .getDocuments();
      final entries = await compute(parseStatEntries, snapshot.documents);
      content.entries = entries;
    }
    if (content.entries == null || content.entries.length == 0)
      content.chartWidget = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.xxxxxl),
          child: Text(
            AppLocalizations.of(context).translate('chart_empty'),
            textAlign: TextAlign.center,
            style: TextStyle(color: MyColors.dark, fontSize: Dimens.font_l),
          ),
        ),
      );
    else {
      final data = await compute(entriesToStackedBarGraphData,
          _StackedBarGraphParams(statItem: widget.statItem, entries: content.entries));
      final List<charts.Series<StackedBarGraphData, String>> seriesList = List();
      for(final list in data) {
        seriesList.add(new charts.Series<StackedBarGraphData, String>(
          id: DateTime.now().toString(),
          domainFn: (StackedBarGraphData entry, _) => entry.label,
          measureFn: (StackedBarGraphData entry, _) => entry.occurrences,
          colorFn: (StackedBarGraphData entry, _) =>
              charts.ColorUtil.fromDartColor(entry.color),
          data: list,
        ));
      }
      content.chartWidget =
          StackedBarChart(seriesList: seriesList);
    }
    content.lastStartDate = widget.startDate;
    content.lastEndDate = widget.endDate;
    content.lastStatItem = widget.statItem;
  }

  @override
  _ChartWidgetStateContent initContent() =>
      content = _ChartWidgetStateContent();
}

class _ChartWidgetStateContent {
  List<StatEntry> entries;
  DateTime lastStartDate;
  DateTime lastEndDate;
  StatItem lastStatItem;
  Widget chartWidget;
}

class StackedBarGraphData {
  final String label;
  final int value;
  final int occurrences;
  Color color;

  StackedBarGraphData({
    @required this.label,
    @required this.value,
    @required this.occurrences,
    this.color,
  });
}

class _StackedBarGraphParams {
  final List<StatEntry> entries;
  final StatItem statItem;

  _StackedBarGraphParams({
    @required this.entries,
    @required this.statItem,
  });
}

List<List<StackedBarGraphData>> entriesToStackedBarGraphData(_StackedBarGraphParams params) {
  return params.entries.toStackedBarGraphData(params.statItem);
}
