import 'package:camera/camera.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/models/stat_form_data.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';

class AppState {
  final CameraController cameraController;
  final User user;
  final String currentPath;
  final String imagePath;
  final RouteAction routeAction;
  final StatFormData toSubmit;
  final FireDbComponent db;

  AppState({
    this.cameraController,
    this.user,
    this.currentPath,
    this.routeAction,
    this.imagePath,
    this.toSubmit,
    this.db
  });

  bool shouldUpdateNav() {
    return routeAction != null && routeAction.destination != currentPath;
  }
}