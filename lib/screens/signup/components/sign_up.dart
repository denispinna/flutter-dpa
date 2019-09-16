import 'package:dpa/app_localization.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/util/text_util.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final authApi = AuthAPI.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                controller: emailController,
                decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate('email_hint'),
                    labelText: AppLocalizations.of(context).translate('email')),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!TextUtil.isEmailValid(value)) {
                    return AppLocalizations.of(context)
                        .translate('invalid_email');
                  }
                  return null;
                },
              )),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.padding_xxxl),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate('password_hint'),
                    labelText:
                        AppLocalizations.of(context).translate('password')),
                obscureText: true,
                validator: (value) {
                  if (value.length < 6) {
                    return AppLocalizations.of(context)
                        .translate('invalid_password');
                  }
                  return null;
                },
              )),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.padding_xxxl),
              child: TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('confirm_password'),
                    labelText: AppLocalizations.of(context)
                        .translate('confirm_password')),
                obscureText: true,
                validator: (value) {
                  if (value != passwordController.text) {
                    return AppLocalizations.of(context)
                        .translate('different_passwords');
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
                  displayMessage('sign_up_message', context);
                  authApi.signUp(
                      emailController.text,
                      passwordController.text,
                      context,
                      (user) => Navigator.of(context).pushNamedAndRemoveUntil(
                          '/main', ModalRoute.withName('/'),
                          arguments: user));
                }
              },
              child: Text(AppLocalizations.of(context).translate('sign_up')),
            )),
          ),
        ],
      ),
    );
  }
}
