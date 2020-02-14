import 'package:dpa/widget/chart/chart_widget.dart';
import 'package:flutter/material.dart';

class StatisticTabs extends StatefulWidget {
  StatisticTabs({Key key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<StatisticTabs> {
  static final contentKey = ValueKey('_StatisticState');
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    recoverContent();
  }

  @override
  Widget build(BuildContext context) {
    _persistContent();
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
          children: _pages,
        ),
      ),
    );
  }

  void initPages() {
    _pages = List();
    _pages.add(PieChartsScreen());
    _pages.add(Icon(Icons.directions_transit));
    _pages.add(Icon(Icons.directions_bike));
  }

  void recoverContent() {
    _pages = PageStorage.of(context).readState(context, identifier: contentKey);
    if (_pages == null) initPages();
  }

  Future _persistContent() async => PageStorage.of(context)
      .writeState(context, _pages, identifier: contentKey);
}
