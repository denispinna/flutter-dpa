import 'package:dpa/components/logger.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/login/login.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/cupertino.dart';

const TAG = "reduceAppState";

AppState reduceAppState(AppState state, dynamic action) {
  User user = state.user;
  List<StatItem> statItems = state.statItems;
  Function(BuildContext) function;

  switch (action.runtimeType) {
    case UserLoginAction:
      final loginAction = action as UserLoginAction;
      user = loginAction.user;
      function = (BuildContext context) =>
          Navigator.pushReplacementNamed(context, MainScreen.PATH);
      break;
    case UserLogoutAction:
      user = null;
      function = (BuildContext context) =>
          Navigator.pushReplacementNamed(context, LoginScreen.PATH);
      break;
    case PushFunctionAction:
      final functionAction = action as PushFunctionAction;
      function = functionAction.function;
      break;
    case AddStatItemsAction:
      final addStatItemsAction = action as AddStatItemsAction;
      statItems.addAll(addStatItemsAction.toAdd);
      break;
  }

  final newState = AppState(
    function: function,
    user: user,
    statItems: statItems,
  );

  Logger.log(TAG, "newState : $newState");

  return newState;
}
