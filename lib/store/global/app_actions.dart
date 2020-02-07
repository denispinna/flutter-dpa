import 'package:dpa/models/user.dart';

abstract class AppAction {}

class UserLoginAction implements AppAction {
  final User user;
  UserLoginAction(this.user);
}

class UserLogoutAction implements AppAction {}

class PictureTakenAction implements AppAction {
  final String filePath;

  PictureTakenAction({this.filePath});
}