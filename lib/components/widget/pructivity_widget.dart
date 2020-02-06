import 'package:dpa/models/productivity.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:dpa/util/text_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductivityLabel extends StatelessWidget {
  final double productivity;
  final double fontSize;
  final bool isDecimal;
  final bool bold;

  const ProductivityLabel({
    @required this.productivity,
    this.fontSize = Dimens.font_ml,
    this.isDecimal = true,
    this.bold = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    bool isInt = productivity.floor() == productivity.round();
    String text;

    if (isDecimal)
      text = isInt ? productivity.toInt().toString() : productivity.toString();
    else
      text =
          productivity.getProductivityLabel(context).upperCaseFirstCharacter();
    TextStyle style = (bold)
        ? TextStyle(
            fontSize: fontSize,
            color: productivity.productivityColor,
            fontWeight: FontWeight.bold)
        : TextStyle(
            fontSize: fontSize,
            color: productivity.productivityColor,
          );

    return Text(
      text,
      textAlign: TextAlign.center,
      style: style,
      maxLines: 1,
    );
  }
}

class ProductivityListWidget extends StatelessWidget {
  final double productivity;

  const ProductivityListWidget(this.productivity) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ProductivityLabel(
          productivity: productivity,
          fontSize: Dimens.font_l,
          bold: true,
        ),
        SizedBox(width: Dimens.xxxs),
        productivity.getProductivityIcon(
          size: Dimens.l,
          filled: true,
        ),
      ],
    );
  }
}

class ProductivityDetailWidget extends StatelessWidget {
  final double productivity;

  const ProductivityDetailWidget(this.productivity) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ProductivityLabel(
          productivity: productivity,
          isDecimal: false,
          bold: true,
        ),
        SizedBox(height: Dimens.xxs),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (productivity.floor() == 0) Icon(
                  MyIcons.star,
                  color: productivity.productivityColor,
                  size: Dimens.l,
                )
              else StarRowWidget(
                  productivity: productivity,
                  iconSize: Dimens.xxl,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class StarRowWidget extends StatelessWidget {
  final double productivity;
  final double iconSize;

  const StarRowWidget({this.productivity, this.iconSize = Dimens.xl}) : super();

  @override
  Widget build(BuildContext context) {
    int floor = productivity.floor();
    bool withHalfStar = productivity.floor() != productivity.round();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < floor; i++)
          productivity.getProductivityIcon(
            size: iconSize,
            filled: true,
          ),
        if (withHalfStar)
          productivity.getProductivityHalfIcon(
            size: iconSize,
            filled: true,
          ),
      ],
    );
  }
}
