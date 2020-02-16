import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatefulWidget {
  final List<StatEntry> entries;
  final StatItem statItem;
  final bool animate;

  DonutChart({
    @required this.entries,
    @required this.statItem,
    this.animate = true,
  });

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends StateWithLoading<DonutChart> {
  List<charts.Series> seriesList;
  List<StatEntry> lastEntries;
  StatItem lastStatItem;

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (shouldLoad()) load(showLoading: true);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.xxl),
      child: charts.PieChart(
        seriesList,
        animate: widget.animate,
        animationDuration: Duration(milliseconds: 500),
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: Dimens.pie_chart_width.toInt(),
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside,
            ),
          ],
        ),
        behaviors: [
          charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              horizontalFirst: true,
              desiredMaxRows: 5,
              desiredMaxColumns: 2,
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black, fontSize: 12),
              cellPadding: EdgeInsets.all(Dimens.xxxs))
        ],
      ),
    );
  }

  @override
  bool shouldLoad() =>
      seriesList == null ||
      lastStatItem != widget.statItem ||
      ListEquality().equals(lastEntries, widget.entries);

  @override
  Future loadFunction() async {
    if (!shouldLoad()) return;

    final data = await compute(entriesToDonutGraphData,
        _DonutGraphParams(statItem: widget.statItem, entries: widget.entries));
    lastEntries = widget.entries;
    lastStatItem = widget.statItem;
    seriesList = [
      new charts.Series<DonutGraphData, String>(
        id: DateTime.now().toString(),
        data: data,
        domainFn: (DonutGraphData entry, _) => entry.label,
        measureFn: (DonutGraphData entry, _) => entry.percentage,
        labelAccessorFn: (DonutGraphData entry, _) =>
            entry.occurrences.toString(),
        colorFn: (DonutGraphData entry, _) =>
            charts.ColorUtil.fromDartColor(entry.color),
      )
    ];
  }
}

List<DonutGraphData> entriesToDonutGraphData(_DonutGraphParams params) {
  return params.entries.toDonutGraphData(params.statItem);
}

class _DonutGraphParams {
  final List<StatEntry> entries;
  final StatItem statItem;

  _DonutGraphParams({
    @required this.entries,
    @required this.statItem,
  });
}

class DonutGraphData {
  final String label;
  final dynamic value;
  final Color color;
  int occurrences;
  double percentage;

  DonutGraphData({
    @required this.label,
    @required this.value,
    @required this.occurrences,
    @required this.color,
  });
}
