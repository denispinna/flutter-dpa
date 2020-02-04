import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Mood { first, second, third, fourth, fifth }

extension MoodExt on Mood {
  Icon get icon {
    switch (this) {
      case Mood.first:
        return Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
          size: Dimens.mood_icon_width,
        );
      case Mood.second:
        return Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.redAccent,
          size: Dimens.mood_icon_width,
        );
      case Mood.third:
        return Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
          size: Dimens.mood_icon_width,
        );
      case Mood.fourth:
        return Icon(
          Icons.sentiment_satisfied,
          color: Colors.lightGreen,
          size: Dimens.mood_icon_width,
        );
      default:
        return Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
          size: Dimens.mood_icon_width,
        );
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case Mood.first:
        return AppLocalizations.of(context).translate('mood_first');
      case Mood.second:
        return AppLocalizations.of(context).translate('mood_second');
      case Mood.third:
        return AppLocalizations.of(context).translate('mood_third');
      case Mood.fourth:
        return AppLocalizations.of(context).translate('mood_fourth');
      default:
        return AppLocalizations.of(context).translate('mood_fifth');
    }
  }
}
