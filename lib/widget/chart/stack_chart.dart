import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart({
    @required this.seriesList,
    this.animate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.m),
      child: charts.BarChart(
        seriesList,
        animate: animate,
        barGroupingType: charts.BarGroupingType.stacked,
      ),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
