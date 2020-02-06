import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/bottom_navigation/animated_bottom_bar.dart';
import 'package:dpa/components/widget/connected_widget.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/input_data_widget.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/screens/main/components/stats_history_widget.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const PATH = "/main";

  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends ScreenState<MainScreen> {
  MainState() : super(MainScreen.PATH);

  final PageStorageBucket bucket = PageStorageBucket();
  InputStat inputWidget;
  StatsHistoryWidget statsWidget;
  ProfileWidget profileWidget;
  List<BarItem> barItems;
  List<Widget> pages;
  User user;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    inputWidget = InputStat(key: PageStorageKey('inputWidget'));
    statsWidget = StatsHistoryWidget(key: PageStorageKey('statsWidget'));
    profileWidget = ProfileWidget(key: PageStorageKey('profileWidget'));

    pages = [inputWidget, statsWidget, Container(), profileWidget];
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    if (barItems == null) setupBarItems();
    user = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
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

  void setupBarItems() {
    barItems = [
      BarItem(
          text: AppLocalizations.of(context).translate('today'),
          iconData: Icons.mood,
          color: MyColors.accent_color_1),
      BarItem(
          text: AppLocalizations.of(context).translate('history'),
          iconData: Icons.accessibility_new,
          color: MyColors.accent_color_2),
      BarItem(
          text: AppLocalizations.of(context).translate('stats'),
          iconData: Icons.bubble_chart,
          color: MyColors.accent_color_3),
      BarItem(
          text: AppLocalizations.of(context).translate('profile'),
          iconData: Icons.person,
          color: MyColors.accent_color_4),
    ];
  }
}
