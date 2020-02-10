import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:dpa/screens/mail_login/components/login_form.dart';
import 'package:flutter/material.dart';

class MailLoginScreen extends StatefulWidget {
  static const PATH = "/login";

  @override
  State<StatefulWidget> createState() => _MailLoginScreenState();
}

class _MailLoginScreenState extends ScreenState<MailLoginScreen> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('app_name')),
      ),
      body: LoginForm(),
    );
  }
}
