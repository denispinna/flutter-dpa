import 'package:dpa/components/widget/base/lifecycle_widget.dart';
import 'package:dpa/screens/login/components/home_widget.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const PATH = "/home";

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends ScreenState<LoginScreen> {
  static const String TAG = "LoginState";
  LoginScreen widget;

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MyImages.home_background,
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: MyImages.home_background, fit: BoxFit.cover),
        ),
        child: Center(child: HomeWidget()),
      ),
    ));
  }
}
