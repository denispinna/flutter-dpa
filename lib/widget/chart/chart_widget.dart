import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/chart/donut_chart.dart';
import 'package:dpa/widget/date/date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class GlobalChartsScreen extends StatefulWidget {
  @override
  _GlobalChartsScreenState createState() => _GlobalChartsScreenState();
}

class _GlobalChartsScreenState
    extends StoreConnectedState<GlobalChartsScreen, List<StatItem>> {
  List<StatItem> statItems;
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
    this.statItems = statItems;
    this.statItem = statItems[1];
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
  List<StatItem> converter(Store store) => store.state.statItems;
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
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends StateWithLoading<ChartWidget> {
  static final contentKey = ValueKey('_ChartWidgetState');
  _ChartWidgetStateContent _content;

  @override
  void initState() {
    recoverContent();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    _persistContent();
    if (shouldLoad()) load();
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 400.0),
      child: _content.chartWidget,
    );
  }

  @override
  Color get backgroundColor => null;

  @override
  bool shouldLoad() =>
      _content.chartWidget == null ||
      _content.entries == null ||
      _content.lastStartDate != widget.startDate ||
      _content.lastEndDate != widget.endDate;

  @override
  Future loadFunction() async {
    if (!shouldLoad()) return;

    var snapshot = await API.statApi
        .getStats(from: widget.startDate, to: widget.endDate)
        .getDocuments();
    final entries = await compute(parseStatEntries, snapshot.documents);
    _content.entries = entries;
    if (entries == null || entries.length == 0)
      _content.chartWidget = Container();
    else
      _content.chartWidget =
          DonutChart.generate(entries, widget.statItem, context);
    _content.lastStartDate = widget.startDate;
    _content.lastEndDate = widget.endDate;
  }

  void initContent() => _content = _ChartWidgetStateContent();

  void recoverContent() {
    _content =
        PageStorage.of(context).readState(context, identifier: contentKey);
    if (_content == null) initContent();
  }

  Future _persistContent() async => PageStorage.of(context)
      .writeState(context, _content, identifier: contentKey);
}

class _ChartWidgetStateContent {
  Widget chartWidget;
  List<StatEntry> entries;
  DateTime lastStartDate;
  DateTime lastEndDate;
}
