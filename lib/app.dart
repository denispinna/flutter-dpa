import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/screens/camera/camera_screen.dart';
import 'package:dpa/screens/login/login.dart';
import 'package:dpa/screens/mail_login/mail_login_screen.dart';
import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/screens/signup/sign_up_screen.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/style.dart';
import 'package:dpa/widget/base/ActionWidget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'widget/base/lifecycle_widget.dart';

class MyApp extends StatefulWidget {
  final Store store;
  final String initialRoute;

  const MyApp({@required this.store, @required this.initialRoute});

  @override
  _ConnectedState createState() => _ConnectedState();
}

class _ConnectedState extends LifecycleWidgetState<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget buildWithLifecycle(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StoreProvider<AppState>(
        store: widget.store,
        child: StoreConnector<AppState, void>(
          converter: (store) => null,
          builder: buildWithStore,
        ));
  }

  Widget buildWithStore(BuildContext context, void ignore) {
    Logger.log(runtimeType.toString(), "buildWithStore  $this");

    return MaterialApp(
        title: 'DPA',
        theme: appTheme(),
        initialRoute: ActionWidget.PATH,
        routes: <String, WidgetBuilder>{
          ActionWidget.PATH: (BuildContext context) =>
              ActionWidget(initialRoute: widget.initialRoute),
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
            Logger.logError(
                runtimeType.toString(), "Error while resolving locale", e);
          }

          return supportedLocales.first;
        });
  }
}
