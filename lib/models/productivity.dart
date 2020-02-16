import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ProductivityExt on int {
  Widget getProductivityHalfIcon(
      {double size = Dimens.rating_icon_width,
      bool filled = true,
      Color color}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: size,
        width: size / 2,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerLeft,
          child: this.getProductivityIcon(
            size: size,
            filled: filled,
          ),
        ),
      ),
    );
  }

  Icon getProductivityIcon(
      {double size = Dimens.rating_icon_width,
      bool filled = true,
      Color color}) {
    switch (this) {
      case 0:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
      case 1:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
      case 2:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
      case 3:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
      case 4:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
      default:
        return Icon(
          filled ? MyIcons.star_filled : MyIcons.star,
          color: color != null ? color : this.productivityColor,
          size: size,
        );
    }
  }

  String productivityLabel() {
    switch (this) {
      case 0:
        return 'productivity_first';
      case 1:
        return 'productivity_second';
      case 2:
        return 'productivity_third';
      case 3:
        return 'productivity_fourth';
      case 4:
        return 'productivity_fifth';
      default:
        return 'productivity_sixth';
    }
  }

  Color get productivityColor {
    switch (this) {
      case 0:
        return MyColors.productivity_0;
      case 1:
        return MyColors.productivity_1;
      case 2:
        return MyColors.productivity_2;
      case 3:
        return MyColors.productivity_3;
      case 4:
        return MyColors.productivity_4;
      default:
        return MyColors.productivity_5;
    }
  }
}

extension ProductivityDoubleExt on double {
  Widget getProductivityHalfIcon(
      {double size = Dimens.rating_icon_width,
      bool filled = false,
      Color color}) {
    return this
        .floor()
        .getProductivityHalfIcon(size: size, filled: filled, color: color);
  }

  Icon getProductivityIcon(
      {double size = Dimens.rating_icon_width,
      bool filled = false,
      Color color}) {
    return this
        .floor()
        .getProductivityIcon(size: size, filled: filled, color: color);
  }

  String getProductivityLabel() {
    return this.floor().productivityLabel();
  }

  Color get productivityColor {
    return this.floor().productivityColor;
  }
}
