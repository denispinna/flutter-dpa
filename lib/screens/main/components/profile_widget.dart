import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfileWidget extends StatelessWidget {
  final authApi = AuthAPI.instance;
  ProfileWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user, builder: buildWithUser);
  }

  Widget buildWithUser(BuildContext context, User user) {
    if(user == null) return Container();
    
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
      StoreConnector<AppState, Function>(
          converter: (store) => () {
                store.dispatch(UserLogoutAction());
              },
          builder: (context, dispatchLogout) {
            return CenterHorizontal(FlatButton(
              onPressed: () =>
                  AuthAPI().signOut(user.signInMethod, dispatchLogout),
              color: MyColors.second,
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
            ));
          }),
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
