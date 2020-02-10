import 'package:dpa/models/user.dart';
import 'package:flutter/cupertino.dart';

abstract class AppAction {}

class UserLoginAction implements AppAction {
  final User user;
  UserLoginAction(this.user);
}

class UserLogoutAction implements AppAction {}

/// Used to push an action that will be executed at the root of the navigation tree */
class PushFunctionAction implements AppAction {
  final Function(BuildContext) function;
  PushFunctionAction(this.function);
}
