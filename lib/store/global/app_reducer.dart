import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/components/logger.dart';

const TAG = "reduceAppState";

AppState reduceAppState(AppState state, dynamic action) {
  User user = state.user;
  String imagePath = state.imagePath;

  switch (action.runtimeType) {
    case UserLoginAction:
      final loginAction = action as UserLoginAction;
      user = loginAction.user;
      //TODO : Replace MainScreen.PATH
      break;
    case UserLogoutAction:
      user = null;
      //TODO : Replace HomeScreen.PATH
      break;
    case PictureTakenAction:
      final pictureAction = action as PictureTakenAction;
      imagePath = pictureAction.filePath;
      /* We only want to pop the current screen if a picture was taken (path != null) */
      if(imagePath != null)
        //TODO : Pop()
      break;
  }

  final newState = AppState(
      user: user,
      imagePath: imagePath);

  Logger.log(TAG, "action : $action");
  Logger.log(TAG, "newState : $newState");

  return newState;
}
