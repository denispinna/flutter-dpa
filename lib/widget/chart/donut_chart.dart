import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  const DonutChart({
    @required this.seriesList,
    this.animate = true,
  });

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
              desiredMaxRows: 5,
              desiredMaxColumns: 2,
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black, fontSize: 12),
              cellPadding: EdgeInsets.all(Dimens.xxxs))
        ],
      ),
    );
  }

}
