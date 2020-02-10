import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/util/text_util.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final authApi = AuthAPI.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function(User)>(
        converter: (store) => (user) {
              store.dispatch(UserLoginAction(user));
            },
        builder: buildWithState);
  }

  Widget buildWithState(BuildContext context, Function(User) onLogin) {
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
            padding: const EdgeInsets.symmetric(vertical: Dimens.padding_m),
            child: CenterHorizontal(RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  displayMessage("login_message", context);

                  authApi.signInWithMail(emailController.text,
                      passwordController.text, context, onLogin);
                }
              },
              child: Text(AppLocalizations.of(context).translate('login')),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.padding_m),
            child: CenterHorizontal(RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('no_account_message')),
                  TextSpan(
                      text: AppLocalizations.of(context).translate('sign_up'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      recognizer: new TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, '/sign_up')),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
