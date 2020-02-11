import 'package:dpa/app.dart';
import 'package:dpa/screens/login/login.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/store/global/app_reducer.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final currentUser = await AuthAPI.instance.loadCurrentUser();
  String initialRoute =
      (currentUser != null) ? MainScreen.PATH : LoginScreen.PATH;

  final initialState = AppState(
    user: currentUser,
    function: null,
    statItems: List(),
  );

  final appStore =
      new Store<AppState>(reduceAppState, initialState: initialState);

  runApp(
    MyApp(
      store: appStore,
      initialRoute: initialRoute,
    ),
  );
}
