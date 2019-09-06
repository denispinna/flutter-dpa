import 'package:dpa/app_localization.dart';
import 'package:dpa/components/centerHorizontal.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.padding_xxxl),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('username_hint'),
                    labelText: AppLocalizations.of(context).translate('username')
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).translate('invalid_username');
                  }
                  return null;
                },
              )),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.padding_xxxl),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('password_hint'),
                    labelText: AppLocalizations.of(context).translate('password')
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).translate('invalid_password');
                  }
                  return null;
                },
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.padding_m),
            child: CenterHorizontal(RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(
                      AppLocalizations.of(context).translate('login_message')
                  )));
                }
              },
              child: Text( AppLocalizations.of(context).translate('login')),
            )),
          ),
        ],
      ),
    );
  }
}
