import 'package:dpa/app_localization.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:flutter/material.dart';

import 'components/sign_up.dart';

class SignUpScreen extends StatefulWidget {
  static const PATH = "/login";

  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends ScreenState<SignUpScreen> {
  SignUpScreenState() : super(SignUpScreen.PATH);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('create_account')),
      ),
      body: SignUpForm(),
    );
  }
}