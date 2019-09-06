import 'package:dpa/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:dpa/screens/login/components/login_form.dart';

class LoginScreen extends StatelessWidget {
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