import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/screens/camera/camera_screen.dart';
import 'package:dpa/screens/login/login.dart';
import 'package:dpa/screens/mail_login/mail_login_screen.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/screens/signup/sign_up_screen.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_reducer.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/style.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final currentUser = await AuthAPI.instance.loadCurrentUser();
  String initialRoute =
      (currentUser != null) ? MainScreen.PATH : LoginScreen.PATH;

  final initialState = AppState(
    user: currentUser,
  );

  final appStore =
      new Store<AppState>(reduceAppState, initialState: initialState);

  runApp(DpaApp(
    store: appStore,
    initialRoute: initialRoute,
  ));
}

FirebaseAnalytics analytics = FirebaseAnalytics();

class DpaApp extends StatefulWidget {
  final Store store;
  final String initialRoute;

  const DpaApp({@required this.store, @required this.initialRoute});

  @override
  DpaAppState createState() => DpaAppState(store);
}

class DpaAppState extends State<DpaApp> {
  static const String TAG = "DpaApp";
  final Store store;

  DpaAppState(this.store);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StoreProvider<AppState>(
        store: store,
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: getAppWidget,
        ));
  }

  Widget getAppWidget(BuildContext context, AppState state) {
    return MaterialApp(
        title: 'DPA',
        theme: appTheme(),
        initialRoute: widget.initialRoute,
        routes: <String, WidgetBuilder>{
          LoginScreen.PATH: (BuildContext context) => LoginScreen(),
          MailLoginScreen.PATH: (BuildContext context) => MailLoginScreen(),
          SignUpScreen.PATH: (BuildContext context) => SignUpScreen(),
          MainScreen.PATH: (BuildContext context) => MainScreen(),
          CameraScreen.PATH: (BuildContext context) => CameraScreen(),
        },
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          try {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
          } catch (e) {
            Logger.logError(TAG, "Error while resolving locale", e);
          }

          return supportedLocales.first;
        });
  }

  @override
  void initState() {
    super.initState();
  }
}
