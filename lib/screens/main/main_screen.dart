import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainState(this);
}

class MainState extends State<MainScreen> {
  MainState(this.widget);

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
        return new DetailedScreen(user: user);
        break;
      case 1:
        return new DetailedScreen(user: user);
        break;
      case 2:
        return new DetailedScreen(user: user);
        break;
      default:
        return new DetailedScreen(user: user);
        break;
    }
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
