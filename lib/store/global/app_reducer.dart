import 'package:camera/camera.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/util/logger.dart';

const TAG = "reduceAppState";

AppState reduceAppState(AppState state, dynamic action) {
  User user = state.user;
  RouteAction routeAction = state.routeAction;
  String currentPath = state.currentPath;
  CameraController cameraController = state.cameraController;

  switch(action.runtimeType) {
    case UserLoginAction :
      final loginAction = action as UserLoginAction;
      user = loginAction.user;
      routeAction = RouteAction(
        destination: "/main",
        type: RouteActionType.Push
      );
      break;
    case UserLogoutAction :
      user = null;
      routeAction = RouteAction(
          destination: "/home",
          type: RouteActionType.Replace
      );
      break;
    case RouteAction :
      routeAction = action as RouteAction;
      break;
    case RouteUpdatedAction :
      final updateAction = action as RouteUpdatedAction;
      currentPath = updateAction.newPath;
      routeAction = null;
      break;
  }

  final newState = AppState(
    cameraController: cameraController,
    user: user,
    currentPath: currentPath,
    routeAction: routeAction
  );

  Logger.log(TAG, "action : $action");
  Logger.log(TAG, "newState : $newState");

  return newState;
}