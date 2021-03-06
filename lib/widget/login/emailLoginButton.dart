import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/widget/centerHorizontal.dart';
import 'package:flutter/material.dart';

class EmailSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  EmailSignInButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return CenterHorizontal(FlatButton(
      onPressed: onPressed,
      color: MyColors.second,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.xxl)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            0, Dimens.padding_xs, 0, Dimens.padding_xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: MyImages.email, height: Dimens.xxl),
            Padding(
              padding: const EdgeInsets.only(left: Dimens.padding_s),
              child: Text(
                AppLocalizations.of(context).translate('email_login'),
                style: TextStyle(
                  fontSize: Dimens.font_m,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
