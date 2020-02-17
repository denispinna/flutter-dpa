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
import 'package:dpa/widget/chart/bar_chart.dart';
import 'package:dpa/widget/date/date_range_picker.dart';
import 'package:dpa/widget/stat/stat_item_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux/src/store.dart';

class BarChartsScreen extends StatefulWidget {
  @override
  _BarChartsScreenState createState() => _BarChartsScreenState();
}

class _BarChartsScreenState
    extends StoreConnectedState<BarChartsScreen, List<StatItem>> {
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
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends StateWithLoading<ChartWidget>
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
      final data = await compute(
          entriesToBarGraphData,
          _BarGraphParams(
              statItem: widget.statItem, entries: content.entries));
      final seriesList = [
        new charts.Series<BarGraphData, String>(
          id: DateTime.now().toString(),
          domainFn: (BarGraphData entry, _) => entry.label,
          measureFn: (BarGraphData entry, _) => entry.value,
          colorFn: (BarGraphData entry, _) =>
              charts.ColorUtil.fromDartColor(entry.color),
          data: data,
        )
      ];
      content.chartWidget = BarChart(seriesList: seriesList);
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

class BarGraphData {
  final DateTime startDate;
  final DateTime endDate;
  final double value;
  Color color;

  BarGraphData({
    @required this.value,
    @required this.startDate,
    @required this.endDate,
    this.color,
  });

  String get label {
    return (startDate.difference(endDate).inDays == 0)
        ? DateFormat("d MMM").format(startDate)
        : "${DateFormat("d MMM").format(startDate)} - ${DateFormat("d MMM").format(endDate)}";
  }
}

class _BarGraphParams {
  final List<StatEntry> entries;
  final StatItem statItem;

  _BarGraphParams({
    @required this.entries,
    @required this.statItem,
  });
}

List<BarGraphData> entriesToBarGraphData(_BarGraphParams params) {
  return params.entries.toBarGraphData(params.statItem);
}
