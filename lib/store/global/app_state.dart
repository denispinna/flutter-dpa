import 'package:camera/camera.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';

class AppState {
  final User user;
  final String imagePath;

  AppState({
    this.user,
    this.imagePath,
  });
}