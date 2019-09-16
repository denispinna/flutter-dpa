import 'package:camera/camera.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/util/text_util.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InputDataWidget extends StatefulWidget {
  final authApi = AuthAPI.instance;

  @override
  InputDataState createState() => InputDataState(this);
}

class InputDataState extends State<InputDataWidget> {
  static const String TAG = "HomeState";
  InputDataWidget widget;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  InputDataState(this.widget);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraController>(
      converter: (store) => store.state.cameraController,
      builder: (context, controller) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.padding_xxxl,
              Dimens.xxxxl,
              Dimens.padding_xxxl,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TakePictureWidget(controller),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('email_hint'),
                        labelText:
                            AppLocalizations.of(context).translate('email')),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!TextUtil.isEmailValid(value)) {
                        return AppLocalizations.of(context)
                            .translate('invalid_email');
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('password_hint'),
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.padding_m),
                    child: CenterHorizontal(RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          displayMessage("login_message", context);
                        }
                      },
                      child:
                          Text(AppLocalizations.of(context).translate('login')),
                    )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.padding_m),
                    child: CenterHorizontal(RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate('no_account_message')),
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .translate('sign_up'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.pushNamed(context, '/sign_up')),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
