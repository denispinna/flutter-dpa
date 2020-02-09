import 'package:camera/camera.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:flutter/cupertino.dart';

class AppState {
  final User user;
  final Function(BuildContext) function;

  AppState({
    this.user,
    this.function,
  });
}