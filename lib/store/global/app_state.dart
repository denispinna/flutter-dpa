import 'package:dpa/models/user.dart';
import 'package:flutter/cupertino.dart';

class AppState {
  final User user;
  final Function(BuildContext) function;

  AppState({
    this.user,
    this.function,
  });
}
