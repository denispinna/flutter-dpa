import 'package:dpa/models/stat_item_parser.dart';
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
    final userEmail = data[StatItemField.user_email.label];
    final isCustom = data[StatItemField.is_custom.label];
    final isEnabled = data[StatItemField.is_enabled.label];
    final localizedLabel = data[StatItemField.localized_label.label];
    final displayInList = data[StatItemField.display_in_list.label];
    final inputLabel = data[StatItemField.input_label.label];
    final outputLabel = data[StatItemField.output_label.label];
    final color = Color(data[StatItemField.color.label]);
    final position = data[StatItemField.position.label];
    final min = data[StatItemField.min.label];
    final max = data[StatItemField.max.label];
    final choicesString = data[StatItemField.choices.label];
    final maxLength = data[StatItemField.max_length.label];
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
  user_email,
  display_in_list,
  is_custom,
  is_enabled,
  localized_label,
  position,
  input_label,
  output_label,
  color,
  type,
  min,
  max,
  max_length,
  choices
}

extension FieldExt on StatItemField {
  String get label => this.toString().split(".")[1];
}