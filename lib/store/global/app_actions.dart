
import 'package:dpa/models/user.dart';

abstract class AppAction {}

class UserLoginAction implements AppAction {
  final User user;
  UserLoginAction(this.user);
}

class UserLogoutAction implements AppAction {}

///Actions related to the navigation
class RouteAction implements AppAction {
  final String destination;
  final RouteActionType type;

  RouteAction({this.destination, this.type});
}

class RouteUpdatedAction implements AppAction {
  final String newPath;

  RouteUpdatedAction(this.newPath);
}

class PictureTakenAction implements AppAction {
  final String filePath;

  PictureTakenAction(this.filePath);
}

enum RouteActionType {
  Pop,
  Push,
  Replace
}