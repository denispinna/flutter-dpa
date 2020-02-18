import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/widget/base/persistent_widget.dart';
import 'package:dpa/widget/chart/donut_chart_screen.dart';
import 'package:dpa/widget/chart/bar_chart_screen.dart';
import 'package:dpa/widget/chart/stack_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StatisticTabs extends StatefulWidget {
  StatisticTabs({Key key}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<StatisticTabs>
    with Persistent<_StatisticStateContent>, SingleTickerProviderStateMixin {
  TabController _controller;
  final List<Widget> _pages = List();

  @override
  void initState() {
    super.initState();
    initPages();
    recoverContent(context: context);
    _controller = TabController(vsync: this, length: 3);
    _controller.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    persistOrRecoverContent(context: context);
    _controller.animateTo(content.index);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _controller,
          tabs: <Widget>[
            Tab(
              icon: SvgPicture.asset(MyImages.donut_chart,
                  height: Dimens.xxl, width: Dimens.l),
            ),
            Tab(
              icon: SvgPicture.asset(MyImages.bar_chart,
                  height: Dimens.xxl, width: Dimens.l),
            ),
            Tab(
              icon: SvgPicture.asset(MyImages.horizontal_line_chart,
                  height: Dimens.xxl, width: Dimens.l),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _pages,
      ),
    );
  }

  void initPages() {
    _pages.add(DonutChartsScreen());
    _pages.add(StackedBarChartsScreen());
    _pages.add(BarChartsScreen());
  }

  _handleTabSelection() {
    content.index = _controller.index;
    persistContent(context: context);
  }

  @override
  _StatisticStateContent initContent() => _StatisticStateContent();
}

class _StatisticStateContent {
  int index;

  _StatisticStateContent({this.index = 0});
}
