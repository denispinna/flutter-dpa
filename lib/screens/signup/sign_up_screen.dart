import 'package:dpa/components/app_localization.dart';
import 'package:dpa/widget/base/lifecycle_widget.dart';
import 'package:flutter/material.dart';

import 'components/sign_up.dart';

class SignUpScreen extends StatefulWidget {
  static const PATH = "/sign_up";

  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends ScreenState<SignUpScreen> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('create_account')),
      ),
      body: SignUpForm(),
    );
  }
}
