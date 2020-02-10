import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:flutter/cupertino.dart';

class AppState {
  final User user;
  final Function(BuildContext) function;
  final List<StatItem> statItems;

  AppState({
    this.user,
    this.function,
    this.statItems,
  });
}
