import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/widget/base/persistent_widget.dart';
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

class _StatisticState extends State<StatisticTabs>
    with Persistent<_StatisticStateContent> {
  final List<Widget> _pages = List();

  @override
  void initState() {
    super.initState();
    initPages();
    recoverContent(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return buildWithStorage(buildWidget(context));
  }

  Widget buildWidget(BuildContext context) {
    persistContent(context: context);
    return DefaultTabController(
      initialIndex: content.index,
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
    _pages.add(DonutChartsScreen());
    _pages.add(StackChartsScreen());
    _pages.add(LineChartsScreen());
  }

  @override
  _StatisticStateContent initContent() => _StatisticStateContent();
}

class _StatisticStateContent {
  int index;

  _StatisticStateContent({this.index = 0});
}
