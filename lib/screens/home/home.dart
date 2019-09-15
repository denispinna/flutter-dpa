import 'package:dpa/components/lifecycle_widget.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:dpa/screens/home/components/home_widget.dart';

class HomeScreen extends StatefulWidget {
  static const PATH = "/home";

  @override
  State<StatefulWidget> createState() => HomeState(this);

  Widget build(BuildContext context) {
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

class HomeState extends ScreenState<HomeScreen> {
  static const String TAG = "HomeState";
  HomeScreen widget;

  HomeState(this.widget) : super(HomeScreen.PATH);

  @override
  Widget build(BuildContext context) {
    return this.widget.build(context);
  }
}
