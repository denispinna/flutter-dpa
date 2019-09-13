import 'package:dpa/services/login.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:dpa/screens/home/components/home_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState(this);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      );
  }
}

class HomeState extends State<HomeScreen> {
  static const String TAG = "HomeState";
  final authApi = AuthAPI.instance;
  var loading = true;

  HomeScreen widget;

  HomeState(this.widget);

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading)
      body = SpinKitWave(
          color: MyColors.second_color, type: SpinKitWaveType.start);
    else
      body = this.widget.build(context);

    return Scaffold(body: body);
  }

  @override
  void initState() {
    super.initState();
    checkLoggedInUser(context);
  }

  void checkLoggedInUser(BuildContext context) {
    authApi.checkLoggedInUser((user) {
      Logger.log(TAG, "checkLoggedInUser : $user");
      setState(() {
        loading = false;
      });
      if (user != null) Navigator.pushNamed(context, '/main', arguments: user);
    });
  }
}
