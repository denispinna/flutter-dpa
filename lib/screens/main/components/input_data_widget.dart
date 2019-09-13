import 'package:dpa/app_localization.dart';
import 'package:dpa/components/centerHorizontal.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/login.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';

class DetailedScreen extends StatelessWidget {
  final authApi = AuthAPI.instance;
  final User user;

  DetailedScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      CenterHorizontal(Padding(
        padding: const EdgeInsets.fromLTRB(
            0, Dimens.padding_xxxxl, 0, Dimens.padding_m),
        child: Container(
          width: Dimens.profile_image_width,
          child: AspectRatio(
            aspectRatio: 1,
            child: ProfileImage(
              imageUrl: user.imageUrl,
            ),
          ),
        ),
      )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, Dimens.padding_xxxxl),
          child: new Text(
            user.email,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontWeight: FontWeight.bold, fontSize: Dimens.font_xl),
          )),
      CenterHorizontal(FlatButton(
        onPressed: () => authApi.signOut(
            user.signInMethod, () => Navigator.of(context).pop()),
        color: MyColors.second_color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.xxl)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              0, Dimens.padding_xxs, 0, Dimens.padding_xxs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: MyImages.logout, height: Dimens.xl),
              Padding(
                padding: const EdgeInsets.only(left: Dimens.padding_s),
                child: Text(
                  AppLocalizations.of(context).translate('logout'),
                  style: TextStyle(
                    fontSize: Dimens.font_l,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ))
    ]);
  }
}

class ProfileImage extends StatelessWidget {
  final String imageUrl;

  const ProfileImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        minRadius: 90,
        maxRadius: 150,
      );
    } else {
      return CircleAvatar(
        backgroundImage: MyImages.user_placeholder,
        minRadius: 90,
        maxRadius: 150,
      );
    }
  }
}
