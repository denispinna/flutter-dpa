import 'package:dpa/components/lifecycle_widget.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/input_data_widget.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const PATH = "/main";

  @override
  State<StatefulWidget> createState() => MainState(this);
}

class MainState extends ScreenState<MainScreen> {
  MainState(this.widget) : super(MainScreen.PATH);

  MainScreen widget;
  User user;
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;

    return new WillPopScope(
      child: Scaffold(
          body: getCurrentTabView(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
              BottomNavigationBarItem(
                  icon:
                      Icon(Icons.ac_unit, color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text('')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_alarm,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  title: new Text(''))
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
    switch (currentIndex) {
      case 0:
        return InputDataWidget();
        break;
      case 1:
        return ProfileWidget();
        break;
      case 2:
        return ProfileWidget();
        break;
      default:
        return ProfileWidget();
        break;
    }
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
