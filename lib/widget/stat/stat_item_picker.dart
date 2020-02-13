import 'package:dpa/components/app_localization.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatItemPicker extends StatelessWidget {
  final StatItem selected;
  final List<StatItem> statItems;
  final Function(StatItem) onItemSelected;

  const StatItemPicker({
    @required this.selected,
    @required this.statItems,
    @required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('pick_chart_item'),
          style: TextStyle(fontSize: Dimens.font_l, color: MyColors.second),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: Dimens.m),
        DropdownButton(
          iconSize: Dimens.xl,
          iconEnabledColor: MyColors.second,
          value: selected,
          items: statItems
              .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.name,
                    style: TextStyle(
                        fontSize: Dimens.font_l, color: MyColors.second),
                    textAlign: TextAlign.center,
                  )))
              .toList(),
          onChanged: onItemSelected,
        ),
      ],
    );
  }
}
