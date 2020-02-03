import 'package:camera/camera.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/screens/home/home.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/components/logger.dart';

const TAG = "reduceAppState";

AppState reduceAppState(AppState state, dynamic action) {
  User user = state.user;
  RouteAction routeAction = state.routeAction;
  String currentPath = state.currentPath;
  CameraController cameraController = state.cameraController;
  String imagePath = state.imagePath;

  switch (action.runtimeType) {
    case UserLoginAction:
      final loginAction = action as UserLoginAction;
      user = loginAction.user;
      routeAction =
          RouteAction(destination: MainScreen.PATH, type: RouteActionType.Push);
      break;
    case UserLogoutAction:
      user = null;
      routeAction = RouteAction(
          destination: HomeScreen.PATH, type: RouteActionType.Replace);
      break;
    case RouteAction:
      routeAction = action as RouteAction;
      break;
    case RouteUpdatedAction:
      final updateAction = action as RouteUpdatedAction;
      currentPath = updateAction.newPath;
      routeAction = null;
      break;
    case PictureTakenAction:
      final pictureAction = action as PictureTakenAction;
      imagePath = pictureAction.filePath;
      /* We only want to pop the current screen if a picture was taken (path != null) */
      if(imagePath != null)
        routeAction = RouteAction(destination: null, type: RouteActionType.Pop);
      else
        routeAction = null;

      break;
  }

  final newState = AppState(
      cameraController: cameraController,
      user: user,
      currentPath: currentPath,
      routeAction: routeAction,
      imagePath: imagePath);

  Logger.log(TAG, "action : $action");
  Logger.log(TAG, "newState : $newState");

  return newState;
}
