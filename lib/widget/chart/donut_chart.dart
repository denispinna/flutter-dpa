import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutChart(this.seriesList, {this.animate = true});

  factory DonutChart.generate(
      List<StatEntry> entries, StatItem statItem, BuildContext context) {
    final data = entries.toDonutGraphData(statItem, context);
    final seriesList = [
      new charts.Series<DonutGraphData, String>(
        id: 'Mood',
        data: data,
        domainFn: (DonutGraphData entry, _) => entry.label,
        measureFn: (DonutGraphData entry, _) => entry.percentage,
        labelAccessorFn: (DonutGraphData entry, _) => entry.occurrences.toString(),
        colorFn: (DonutGraphData entry, _) =>
            charts.ColorUtil.fromDartColor(entry.color),
      )
    ];
    return DonutChart(seriesList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.xxl),
      child: charts.PieChart(
        seriesList,
        animate: animate,
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
            cellPadding: EdgeInsets.all(Dimens.xxxs)
          )
        ],
      ),
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
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
