import 'package:dpa/screens/signup/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpa/blocprovs/example-bloc-prov.dart';
import 'package:dpa/blocs/example-bloc.dart';
import 'package:dpa/theme/style.dart';
import 'package:dpa/screens/login/login_screen.dart';
import 'package:dpa/screens/home/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localization.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExampleProvider(
      bloc: ExampleBloc(),
      child: MaterialApp(
          title: 'ExampleApp',
          theme: appTheme(),
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            "/": (BuildContext context) => LoginScreen(),
            "/home": (BuildContext context) => HomeScreen(),
            "/sign_up": (BuildContext context) => SignUpScreen(),
          },
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          }),
    );
  }
}
