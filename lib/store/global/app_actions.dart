import 'package:dpa/models/user.dart';
import 'package:flutter/cupertino.dart';

abstract class AppAction {}

class UserLoginAction implements AppAction {
  final User user;
  UserLoginAction(this.user);
}

class UserLogoutAction implements AppAction {}

class PictureTakenAction implements AppAction {
  final String filePath;

  PictureTakenAction({@required this.filePath});
}

class RemovePictureAction implements AppAction {}