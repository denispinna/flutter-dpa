import 'package:dpa/widget/base/loading_widget.dart';
import 'package:dpa/widget/chart/chart_widget.dart';
import 'package:flutter/material.dart';

class StatisticTabs extends StatefulWidget {
  StatisticTabs({Key key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<StatisticTabs> {
  static final contentKey = ValueKey('_StatisticState ');
  _StateData content;

  @override
  Widget build(BuildContext context) {
    _persisAndRecoverContent(context);
    if (content.loading) {
      return LoadingWidget(showLabel: false);
    } else {
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
              GlobalChartsScreen(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      );
    }
  }

  void _persisAndRecoverContent(BuildContext context) {
    if (content == null) {
      content =
          PageStorage.of(context).readState(context, identifier: contentKey);
      this.content = content == null ? _StateData() : content;
    } else {
      persistContent(context);
    }
  }

  Future persistContent(BuildContext context) async {
    PageStorage.of(context)
        .writeState(context, content, identifier: contentKey);
  }
}

class _StateData {
  bool loading = false;
}
