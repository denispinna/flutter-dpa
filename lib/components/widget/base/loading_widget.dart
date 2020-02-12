import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool showLabel;
  final String label;

  const LoadingWidget({
    this.showLabel = true,
    this.label = 'loading',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: Dimens.loading_width,
            height: Dimens.loading_width,
            child: CircularProgressIndicator(
              strokeWidth: 0.5,
              valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
            ),
          ),
          if (showLabel) SizedBox(height: Dimens.m),
          if (showLabel)
            Text(
              AppLocalizations.of(context).translate(label),
              style:
                  TextStyle(fontSize: Dimens.font_ml, color: MyColors.second),
            ),
        ],
      ),
    );
  }
}
