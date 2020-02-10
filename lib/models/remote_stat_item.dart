import 'package:dpa/models/stat_parser.dart';
import 'package:flutter/material.dart';

class RemoteStatItem {
  final String key;
  final String userEmail;
  final bool displayInList;
  final bool isCustom;
  final bool isEnabled;
  final bool localizedLabel;
  final int position;
  final String inputLabel;
  final String outputLabel;
  final Color color;
  final double min;
  final double max;
  final int maxLength;
  final List<String> choices;
  final String type;

  RemoteStatItem({
    @required this.key,
    @required this.userEmail,
    @required this.displayInList,
    @required this.isCustom,
    @required this.isEnabled,
    @required this.localizedLabel,
    @required this.position,
    @required this.inputLabel,
    @required this.outputLabel,
    @required this.color,
    @required this.min,
    @required this.max,
    @required this.maxLength,
    @required this.choices,
    @required this.type,
  });

  static RemoteStatItem fromFirestoreData(Map<String, dynamic> data) {
    final key = data[StatItemField.key.label];
    final userEmail = data[StatItemField.userEmail.label];
    final isCustom = data[StatItemField.isCustom.label];
    final isEnabled = data[StatItemField.isEnabled.label];
    final localizedLabel = data[StatItemField.localizedLabel.label];
    final displayInList = data[StatItemField.displayInList.label];
    final inputLabel = data[StatItemField.inputLabel.label];
    final outputLabel = data[StatItemField.outputLabel.label];
    final color = Color(data[StatItemField.color.label]);
    final position = data[StatItemField.position.label];
    final min = data[StatItemField.min.label];
    final max = data[StatItemField.max.label];
    final choicesString = data[StatItemField.choices.label];
    final maxLength = data[StatItemField.maxLength.label];
    final type = data[StatItemField.type.label];
    final choices = (choicesString != null)
        ? (choicesString as String).split(SPLIT_CHAR)
        : null;

    return RemoteStatItem(
      key: key,
      userEmail: userEmail,
      isCustom: isCustom,
      isEnabled: isEnabled,
      localizedLabel: localizedLabel,
      displayInList: displayInList,
      inputLabel: inputLabel,
      outputLabel: outputLabel,
      color: color,
      position: position,
      min: min,
      max: max,
      type: type,
      maxLength: maxLength,
      choices: choices,
    );
  }
}

enum StatItemField {
  key,
  userEmail,
  displayInList,
  isCustom,
  isEnabled,
  localizedLabel,
  position,
  inputLabel,
  outputLabel,
  color,
  type,
  min,
  max,
  maxLength,
  choices
}

extension FieldExt on StatItemField {
  String get label {
    switch (this) {
      case StatItemField.key:
        return 'key';
      case StatItemField.userEmail:
        return 'userEmail';
      case StatItemField.displayInList:
        return 'displayInList';
      case StatItemField.isCustom:
        return 'isCustom';
      case StatItemField.isEnabled:
        return 'isEnabled';
      case StatItemField.localizedLabel:
        return 'localizedLabel';
      case StatItemField.position:
        return 'position';
      case StatItemField.inputLabel:
        return 'inputLabel';
      case StatItemField.outputLabel:
        return 'outputLabel';
      case StatItemField.color:
        return 'color';
      case StatItemField.type:
        return 'type';
      case StatItemField.min:
        return 'min';
      case StatItemField.max:
        return 'max';
      case StatItemField.maxLength:
        return 'maxLength';
      case StatItemField.choices:
        return 'choices';
      default:
        return null;
    }
  }
}