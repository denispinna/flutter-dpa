import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/chart/chart_widget.dart';
import 'package:flutter/material.dart';

class StatisticTabs extends StatefulWidget {
  StatisticTabs({Key key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends StateWithLoading<StatisticTabs> {
  GlobalChartsScreen globalChartsScreen;

  @override
  Widget buildWidget(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            globalChartsScreen,
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  @override
  Future loadFunction() async {
    globalChartsScreen = GlobalChartsScreen();
  }
}
