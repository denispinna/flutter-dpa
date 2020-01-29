import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/input_data_widget.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/screens/main/components/stats_history_widget.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/util/view_util.dart';
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
  List<Widget> pages;
  User user;
  var currentIndex = 0;


  @override
  void initState() {
    super.initState();
     inputWidget = InputStat(key: PageStorageKey('inputWidget'));
     statsWidget = StatsHistoryWidget(key: PageStorageKey('statsWidget'));
     profileWidget = ProfileWidget(key: PageStorageKey('profileWidget'));
     pages = [inputWidget, statsWidget, profileWidget];
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;

    return new WillPopScope(
      child: Scaffold(
          backgroundColor: MyColors.light_background,
          body: getCurrentTabView(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.mood, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.accessibility_new, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
            ],
            onTap: (index) {
              onTabTapped(index);
            },
          )),
      onWillPop: () {
        askToLeaveApp(context);
        return new Future(() => false);
      },
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
}
