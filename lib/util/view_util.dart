import 'dart:io';

import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void displayMessage(String messageKey, BuildContext context,
    {bool isError = false, bool isSuccess = false}) {
  String message = AppLocalizations.of(context).translate(messageKey);
  var backgroundColor = MyColors.second;
  if (isError)
    backgroundColor = MyColors.error;
  else if (isSuccess)
    backgroundColor = MyColors.success;

  try {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  } catch (e) {
    Logger.logError(
        "displayMessage", "Error while trying to display a message ", e);
  }
}

Future askToLeaveApp(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context).translate("leave_app")),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppLocalizations.of(context).translate("leave_app_message"))
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate("no")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate("yes")),
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                //This case should never happen, because there is no back button on iOS
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            },
          ),
        ],
      );
    },
  );
}

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
