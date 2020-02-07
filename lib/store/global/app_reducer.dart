import 'package:dpa/models/user.dart';
import 'package:dpa/screens/login/login.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/components/logger.dart';
import 'package:flutter/cupertino.dart';

const TAG = "reduceAppState";

AppState reduceAppState(AppState state, dynamic action) {
  User user = state.user;
  String imagePath = state.imagePath;
  Function(BuildContext) function;

  switch (action.runtimeType) {
    case UserLoginAction:
      final loginAction = action as UserLoginAction;
      user = loginAction.user;
      function = (BuildContext context) => Navigator.pushReplacementNamed(context, MainScreen.PATH);
      break;
    case UserLogoutAction:
      user = null;
      function = (BuildContext context) => Navigator.pushReplacementNamed(context, LoginScreen.PATH);
      break;
    case PictureTakenAction:
      final pictureAction = action as PictureTakenAction;
      imagePath = pictureAction.filePath;
      /* We only want to pop the current screen if a picture was taken (path != null) */
      if(imagePath != null)
        function = (BuildContext context) => Navigator.pop(context);
      break;
  }

  final newState = AppState(
      function: function,
      user: user,
      imagePath: imagePath);

  Logger.log(TAG, "newState : $newState");

  return newState;
}
