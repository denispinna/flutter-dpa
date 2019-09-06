import 'package:dpa/app_localization.dart';
import 'package:flutter/material.dart';

import 'components/sign_up.dart';

class SignUpScreen extends StatelessWidget {
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