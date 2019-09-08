import 'package:dpa/models/user.dart';
import 'package:dpa/screens/main/components/profile_widget.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;

    return new WillPopScope(
      child: Scaffold(
        body: new DetailedScreen(user: user),
      ),
      onWillPop: () {
        askToLeaveApp(context);
        return new Future(() => false);
      },
    );
  }
}