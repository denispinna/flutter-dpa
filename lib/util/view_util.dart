import 'package:dpa/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:flutter/material.dart';

void displayMessage(String messageKey, BuildContext context,
    {bool isError = false}) {
  String message = AppLocalizations.of(context).translate(messageKey);
  var backgroundColor = MyColors.second_color;
  if (isError) {
    backgroundColor = MyColors.error_color;
  }
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  ));
}

void askToLeaveApp(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new WillPopScope(
        child: Scaffold(
            body: AlertDialog(
          title: Text(AppLocalizations.of(context).translate("leave_app")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    AppLocalizations.of(context).translate("leave_app_message"))
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
                Navigator.of(context).pop();
              },
            ),
          ],
        )),
        onWillPop: () {
          return new Future(() => false);
        },
      );
    },
  );
}
