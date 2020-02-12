import 'package:dpa/components/app_localization.dart';
import 'package:dpa/models/stat_item_parser.dart';
import 'package:dpa/screens/main/components/input_data_widget.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/screens/main/components/statistic_screen.dart';
import 'package:dpa/screens/main/components/stats_history_widget.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/base/lifecycle_widget.dart';
import 'package:dpa/widget/bottom_navigation/animated_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class MainScreen extends StatefulWidget {
  static const PATH = "/main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ScreenState<MainScreen> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return _MainStoreConnectedWidget();
  }

  @override
  bool get leaveAppOnPop => true;
}

class _MainStoreConnectedWidget extends StatefulWidget {
  @override
  _MainStoreConnectedWidgetState createState() =>
      _MainStoreConnectedWidgetState();
}

class _MainStoreConnectedWidgetState extends StoreConnectedState<
    _MainStoreConnectedWidget, Function(AppAction)> {
  @override
  Widget buildWithStore(
      BuildContext context, Function(AppAction) dispatchAction) {
    return _MainWidget(dispatchAction);
  }

  @override
  Function(AppAction) converter(Store store) =>
      (action) => (store.dispatch(action));
}

class _MainWidget extends StatefulWidget {
  final Function(AppAction) dispatchAction;

  const _MainWidget(this.dispatchAction);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends StateWithLoading<_MainWidget> {
  final PageStorageBucket bucket = PageStorageBucket();
  List<BarItem> barItems;
  List<Widget> pages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    InputStat inputWidget = InputStat(key: PageStorageKey('inputWidget'));
    StatsHistoryWidget statsWidget =
        StatsHistoryWidget(key: PageStorageKey('statsWidget'));
    ProfileWidget profileWidget =
        ProfileWidget(key: PageStorageKey('profileWidget'));
    StatisticTabs statisticWidget =
        StatisticTabs(key: PageStorageKey('statisticWidget'));
    pages = [inputWidget, statsWidget, statisticWidget, profileWidget];
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (barItems == null) setupBarItems();
    return Scaffold(
      backgroundColor: MyColors.light_background,
      body: pages[currentIndex],
      bottomNavigationBar: AnimatedBottomBar(
          barItems: barItems,
          animationDuration: const Duration(milliseconds: 150),
          barStyle: BarStyle(fontSize: Dimens.font_m, iconSize: Dimens.l),
          onBarTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void setupBarItems() {
    barItems = [
      BarItem(
          text: AppLocalizations.of(context).translate('today'),
          iconData: MyIcons.plus,
          color: MyColors.accent_color_1),
      BarItem(
          text: AppLocalizations.of(context).translate('history'),
          iconData: MyIcons.calendar,
          color: MyColors.accent_color_2),
      BarItem(
          text: AppLocalizations.of(context).translate('stats'),
          iconData: MyIcons.pie_chart,
          color: MyColors.accent_color_3),
      BarItem(
          text: AppLocalizations.of(context).translate('profile'),
          iconData: MyIcons.profile,
          color: MyColors.accent_color_4),
    ];
  }

  @override
  Future loadFunction() async {
    await Future.delayed(Duration(milliseconds: 200));
    await API.statApi.setupDefaultItems();
    final query = await API.statApi.getEnabledStatItems().getDocuments();
    final statItems = await compute(parseStatItems, query.documents);
    if (widget.dispatchAction == null) return;
    widget.dispatchAction(AddStatItemsAction(statItems));
  }
}
