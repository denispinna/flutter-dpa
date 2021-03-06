import 'package:dpa/components/app_localization.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class MoodLabel extends StatelessWidget {
  final Mood mood;

  const MoodLabel(this.mood) : super();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).translate(mood.getLabel()).toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Dimens.font_ml,
          fontWeight: FontWeight.bold,
          color: mood.color),
      maxLines: 1,
    );
  }
}
