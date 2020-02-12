import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Mood { first, second, third, fourth, fifth }

extension MoodExt on Mood {
  Icon get icon {
    switch (this) {
      case Mood.first:
        return Icon(
          MyIcons.mood26,
          color: this.color,
          size: Dimens.rating_icon_width,
        );
      case Mood.second:
        return Icon(
          MyIcons.mood15,
          color: this.color,
          size: Dimens.rating_icon_width,
        );
      case Mood.third:
        return Icon(
          MyIcons.mood25,
          color: this.color,
          size: Dimens.rating_icon_width,
        );
      case Mood.fourth:
        return Icon(
          MyIcons.mood13,
          color: this.color,
          size: Dimens.rating_icon_width,
        );
      default:
        return Icon(
          MyIcons.mood20,
          color: this.color,
          size: Dimens.rating_icon_width,
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

  Color get color {
    switch (this) {
      case Mood.first:
        return Colors.red;
      case Mood.second:
        return Colors.redAccent.withOpacity(0.9);
      case Mood.third:
        return Colors.amber;
      case Mood.fourth:
        return Colors.lightGreen;
      default:
        return Colors.green;
    }
  }
}
