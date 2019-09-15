import 'package:dpa/components/camera_widget.dart';
import 'package:dpa/services/auth.dart';
import 'package:flutter/material.dart';

class InputDataWidget extends StatefulWidget {
  final authApi = AuthAPI.instance;

  @override
  InputDataState createState() => InputDataState(this);

  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      CameraWidget(),
    ]);
  }
}

class InputDataState extends State<InputDataWidget> {
  static const String TAG = "HomeState";
  InputDataWidget widget;

  InputDataState(this.widget);

  @override
  Widget build(BuildContext context) {
    return this.widget.build(context);
  }

  @override
  void initState() {
    super.initState();
  }
}
