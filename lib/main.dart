import 'package:dpa/screens/main/main_screen.dart';
import 'package:dpa/screens/signup/sign_up_screen.dart';
import 'package:dpa/util/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:dpa/blocprovs/example-bloc-prov.dart';
import 'package:dpa/blocs/example-bloc.dart';
import 'package:dpa/theme/style.dart';
import 'package:dpa/screens/login/login_screen.dart';
import 'package:dpa/screens/home/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localization.dart';

void main() {
  runApp(DpaApp());
}

FirebaseAnalytics analytics = FirebaseAnalytics();

class DpaApp extends StatelessWidget {
  static const String TAG = "DpaApp";

  @override
  Widget build(BuildContext context) {
    return ExampleProvider(
      bloc: ExampleBloc(),
      child: MaterialApp(
          title: 'ExampleApp',
          theme: appTheme(),
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            "/": (BuildContext context) => HomeScreen(),
            "/login": (BuildContext context) => LoginScreen(),
            "/sign_up": (BuildContext context) => SignUpScreen(),
            "/main": (BuildContext context) => MainScreen(),
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
            } catch(e) {
              Logger.logError(TAG, "Error while resolving locale", e);
            }

            return supportedLocales.first;
          }),
    );
  }
}
