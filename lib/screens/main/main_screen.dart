import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/bottom_navigation/animated_bottom_bar.dart';
import 'package:dpa/components/widget/connected_widget.dart';
import 'package:dpa/components/widget/loading_widget.dart';
import 'package:dpa/models/stat_parser.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/input_data_widget.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/screens/main/components/stats_history_widget.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class MainScreen extends StatefulWidget {
  static const PATH = "/main";

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends CustomConnectedScreenState<MainScreen,
    Function(AppAction)> {
  final PageStorageBucket bucket = PageStorageBucket();
  InputStat inputWidget;
  StatsHistoryWidget statsWidget;
  ProfileWidget profileWidget;
  List<BarItem> barItems;
  List<Widget> pages;
  User user;
  int currentIndex = 0;
  bool synchronized = false;
  Function(AppAction) dispatchAction;

  @override
  void initState() {
    super.initState();
    inputWidget = InputStat(key: PageStorageKey('inputWidget'));
    statsWidget = StatsHistoryWidget(key: PageStorageKey('statsWidget'));
    profileWidget = ProfileWidget(key: PageStorageKey('profileWidget'));

    pages = [inputWidget, statsWidget, Container(), profileWidget];
    sync();
  }

  @override
  Widget buildWithStore(BuildContext context, Function(AppAction) dispatchAction) {
    this.dispatchAction = dispatchAction;
    if (!synchronized)
      return Scaffold(backgroundColor: MyColors.light, body: LoadingWidget());


    if (barItems == null) setupBarItems();
    user = ModalRoute.of(context).settings.arguments;
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

  Widget getCurrentTabView() {
    return PageStorage(
      child: pages[currentIndex],
      bucket: bucket,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  bool get leaveAppOnPop => true;

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

  Future sync() async {
    await Future.delayed(Duration(milliseconds: 500));
    await API.statApi.setupDefaultItems();
    final query = await API.statApi
        .getEnabledStatItem()
        .getDocuments()
        .catchError((error) => {
              //TODO: Show an error state here
              Logger.logError(runtimeType.toString(),
                  "Error while fetching stat items", error)
            });
    final statItems = await compute(parseStatItems, query.documents);
    this.dispatchAction(AddStatItemsAction(statItems));
    this.synchronized = true;
    setState(() {});
  }

  @override
  Function(AppAction) converter(Store store) =>
      (action) => (store.dispatch(action));
}