import 'package:flutter/cupertino.dart';

abstract class StatItem<T> {
  final String key;
  final String userEmail;
  final String name;
  final bool displayInList;
  final bool isCustom;
  final bool isEnabled;
  final bool localizedLabel;
  final int position;
  final String inputLabel;
  final String outputLabel;
  final Color color;

  const StatItem({
    @required this.key,
    @required this.userEmail,
    @required this.name,
    @required this.inputLabel,
    @required this.outputLabel,
    @required this.localizedLabel,
    @required this.color,
    @required this.displayInList,
    @required this.isCustom,
    @required this.isEnabled,
    @required this.position,
  });

  Widget getInputWidget({
    @required BuildContext context,
    @required Function(T) onValueChanged,
    T initialValue,
  });

  Widget getOutputListWidget({
    @required BuildContext context,
    @required T value,
  });

  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required T value,
  });
}

class QuantityStatItem extends StatItem<double> {
  final double min;
  final double max;
  final bool halfRating;

  const QuantityStatItem({
    @required String key,
    @required String userEmail,
    @required String name,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool localizedLabel,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required Color color,
    @required int position,
    @required this.min,
    @required this.max,
    this.halfRating = false,
  }) : super(
          userEmail: userEmail,
          name: name,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  @override
  Widget getInputWidget({
    @required BuildContext context,
    @required Function(double) onValueChanged,
    double initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required double value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required double value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}

class TextStatItem extends StatItem<String> {
  final int maxLength;

  const TextStatItem({
    @required String key,
    @required String userEmail,
    @required String name,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required bool localizedLabel,
    @required Color color,
    @required int position,
    @required this.maxLength,
  }) : super(
          userEmail: userEmail,
          name: name,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  Widget getInputWidget({
    @required BuildContext context,
    @required Function(String) onValueChanged,
    String initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  @override
  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}

class McqStatItem extends StatItem<String> {
  final List<String> choices;

  const McqStatItem({
    @required String key,
    @required String userEmail,
    @required String name,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required bool localizedLabel,
    @required Color color,
    @required int position,
    @required this.choices,
  }) : super(
          userEmail: userEmail,
          name: name,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  @override
  Widget getInputWidget({
    @required BuildContext context,
    @required Function(String) onValueChanged,
    String initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  @override
  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}
