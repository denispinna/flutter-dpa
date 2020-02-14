import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/widget/chart/donut_chart_screen.dart';
import 'package:dpa/widget/chart/line_chart_screen.dart';
import 'package:dpa/widget/chart/stack_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StatisticTabs extends StatefulWidget {
  StatisticTabs({Key key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

//TODO: Save the page index
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
              Tab(
                icon: SvgPicture.asset(MyImages.donut_chart,
                    height: Dimens.xxl, width: Dimens.xxl),
              ),
              Tab(
                icon: SvgPicture.asset(MyImages.bar_chart,
                    height: Dimens.xxl, width: Dimens.xxl),
              ),
              Tab(
                icon: SvgPicture.asset(MyImages.line_chart,
                    height: Dimens.xxl, width: Dimens.xxl),
              ),
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
    _pages.add(StackChartsScreen());
    _pages.add(LineChartsScreen());
  }

  void recoverContent() {
    _pages = PageStorage.of(context).readState(context, identifier: contentKey);
    if (_pages == null) initPages();
  }

  Future _persistContent() async => PageStorage.of(context)
      .writeState(context, _pages, identifier: contentKey);
}
