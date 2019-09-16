import 'package:dpa/app_localization.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleSignInButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return CenterHorizontal(FlatButton(
      color: Colors.white,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.xxl)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            0, Dimens.padding_xs, 0, Dimens.padding_xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: MyImages.google_logo, height: Dimens.xxl),
            Padding(
              padding: const EdgeInsets.only(left: Dimens.padding_s),
              child: Text(
                AppLocalizations.of(context).translate('google_login'),
                style: TextStyle(
                  fontSize: Dimens.font_m,
                  color: Colors.grey[600],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
