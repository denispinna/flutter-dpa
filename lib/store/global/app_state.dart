import 'package:camera/camera.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';

class AppState {
  final User user;
  final String currentPath;
  final String imagePath;
  final RouteAction routeAction;

  AppState({
    this.user,
    this.currentPath,
    this.routeAction,
    this.imagePath,
  });

  bool shouldUpdateNav() {
    return routeAction != null && routeAction.destination != currentPath;
  }
}