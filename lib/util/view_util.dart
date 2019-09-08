import 'package:dpa/app_localization.dart';
import 'package:flutter/material.dart';

void displayMessage(String messageKey, BuildContext context) {
  String message = AppLocalizations.of(context).translate(messageKey);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
}
