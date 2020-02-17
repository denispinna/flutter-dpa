import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineChart({
    @required this.seriesList,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.s, 0,0,0),
      child: new charts.BarChart(
        seriesList,
        animate: animate,
        vertical: false,
      ),
    );
  }
}
