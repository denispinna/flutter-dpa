import 'package:dpa/app_localization.dart';
import 'package:dpa/components/login/emailLoginButton.dart';
import 'package:dpa/components/login/facebookLoginButton.dart';
import 'package:dpa/components/login/googleLoginButton.dart';
import 'package:dpa/components/title.dart';
import 'package:dpa/services/login.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final authApi = AuthAPI();

  @override
  Widget build(BuildContext context) {
    authApi.signOutWithGoogle();
    authApi.signOutWithFacebook();

    return Container(
        color: const Color(0x88ffffff),
        child: ListView(shrinkWrap: true, children: <Widget>[
          MyTitle(AppLocalizations.of(context).translate('welcome_message')),
          FacebookSignInButton(() => authApi.signInWithFacebook(context)),
          OrRow(),
          GoogleSignInButton(() => authApi.signInWithGoogle(context)),
          OrRow(),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, Dimens.padding_l),
              child: EmailSignInButton(
                  () => Navigator.pushNamed(context, '/login'))),
        ]));
  }
}

class OrRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(
                left: Dimens.large_space, right: Dimens.l),
            child: Divider(
              color: Colors.black,
              height: Dimens.xxxxxl,
            )),
      ),
      Text(AppLocalizations.of(context).translate('or')),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(
                left: Dimens.l, right: Dimens.large_space),
            child: Divider(
              color: Colors.black,
              height: Dimens.xxxxxl,
            )),
      ),
    ]);
  }
}
