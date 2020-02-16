import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/base/persistent_widget.dart';
import 'package:dpa/widget/chart/donut_chart.dart';
import 'package:dpa/widget/date/date_range_picker.dart';
import 'package:dpa/widget/stat/stat_item_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class DonutChartsScreen extends StatefulWidget {
  @override
  _DonutChartsScreenState createState() => _DonutChartsScreenState();
}

class _DonutChartsScreenState
    extends StoreConnectedState<DonutChartsScreen, List<StatItem>> {
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
          SizedBox(height: Dimens.s),
          StatItemPicker(
            statItems: statItems,
            selected: statItem,
            onItemSelected: (item) {
              statItem = item;
              setState(() {});
            },
          ),
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
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends StateWithLoading<ChartWidget>
    with Persistent<_ChartWidgetStateContent> {
  _ChartWidgetStateContent _content;
  Widget chartWidget;

  @override
  void initState() {
    recoverContent(context: context);
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    persistOrRecoverContent(context: context);
    if (shouldLoad()) load();

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 400.0),
      child: chartWidget,
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
      chartWidget == null ||
      _content.entries == null ||
      _content.lastStatItem != widget.statItem ||
      _content.lastStartDate != widget.startDate ||
      _content.lastEndDate != widget.endDate;

  @override
  Future loadFunction() async {
    if (!shouldLoad()) return;

    if (_content.lastStartDate != widget.startDate ||
        _content.lastEndDate != widget.endDate) {
      final snapshot = await API.statApi
          .getStats(from: widget.startDate, to: widget.endDate)
          .getDocuments();
      final entries = await compute(parseStatEntries, snapshot.documents);
      _content.entries = entries;
    }
    //TODO: Add empty state here
    if (_content.entries == null || _content.entries.length == 0)
      chartWidget = Container(width: 0);
    else
      chartWidget =
          DonutChart(entries: _content.entries, statItem: widget.statItem);
    _content.lastStartDate = widget.startDate;
    _content.lastEndDate = widget.endDate;
    _content.lastStatItem = widget.statItem;
  }

  @override
  _ChartWidgetStateContent initContent() =>
      _content = _ChartWidgetStateContent();
}

class _ChartWidgetStateContent {
  List<StatEntry> entries;
  DateTime lastStartDate;
  DateTime lastEndDate;
  StatItem lastStatItem;
}
