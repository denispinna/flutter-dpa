import 'package:dpa/app_localization.dart';
import 'package:dpa/components/lifecycle_widget.dart';
import 'package:flutter/material.dart';
import 'package:dpa/screens/login/components/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const PATH = "/login";

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}
class LoginScreenState extends ScreenState<LoginScreen> {

  LoginScreenState() : super(LoginScreen.PATH);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('app_name')),
      ),
      body: LoginForm(),
    );
  }
}