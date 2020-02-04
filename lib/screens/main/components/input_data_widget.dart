import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/file_manager.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InputStat extends StatefulWidget {
  InputStat({Key key}) : super(key: key);

  @override
  InputItemState createState() => InputItemState();
}

class InputItemState extends State<InputStat> {
  static const String TAG = "InputItemState";
  static final contentKey = ValueKey(TAG);
  final _formKey = GlobalKey<FormState>();
  Function clearPicture;
  TakePictureWidget pictureWidget;
  StateData content;
  bool formPosted = false;

  @override
  Widget build(BuildContext context) {
    persistAndRecoverContent(context);
    if (content.loading) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(Dimens.l),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
        ),
      ));
    } else if (formPosted) {
      clearPicture();
      displayMessage('post_stat_success', context, isSuccess: true);
      formPosted = false;
    }
    return StoreConnector<AppState, User>(
      converter: (store) {
        final state = store.state;
        if (content.imagePath != state.imagePath)
          content.imagePath = state.imagePath;
        if (pictureWidget == null)
          pictureWidget = TakePictureWidget(state.cameraController);
        if (clearPicture == null)
          clearPicture = () => store.dispatch(PictureTakenAction(null));

        return state.user;
      },
      builder: (context, user) {
        this.content.userEmail = user.email;
        return ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  pictureWidget,
                  Padding(
                      padding: const EdgeInsets.only(top: Dimens.padding_xs)),
                  CenterHorizontal(Text(
                    AppLocalizations.of(context).translate('mood_label'),
                    style: TextStyle(
                        color: MyColors.dark, fontSize: Dimens.title_font),
                  )),
                  Padding(padding: const EdgeInsets.only(top: Dimens.xxxxs)),
                  CenterHorizontal(RatingBar(
                    initialRating: content.mood,
                    itemCount: 5,
                    itemSize: Dimens.rating_icon_width,
                    itemBuilder: (context, index) {
                      return getMoodIcon(index + 1);
                    },
                    onRatingUpdate: (rating) {
                      content.mood = rating;
                    },
                  )),
                  Padding(padding: const EdgeInsets.only(top: Dimens.xxxxs)),
                  CenterHorizontal(Text(
                    AppLocalizations.of(context)
                        .translate('productivity_label'),
                    style: TextStyle(
                        color: MyColors.dark, fontSize: Dimens.title_font),
                  )),
                  Padding(padding: const EdgeInsets.only(top: Dimens.xxxs)),
                  CenterHorizontal(RatingBar(
                    initialRating: content.productivity,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: Dimens.rating_icon_width,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: MyColors.yellow,
                    ),
                    onRatingUpdate: (rating) {
                      content.productivity = rating;
                    },
                  )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.padding_xxxl),
                      child: TextFormField(
                        initialValue: content.comment,
                        onChanged: (text) => content.comment = text,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('comment_hint'),
                            labelText: AppLocalizations.of(context)
                                .translate('comment')),
                      )),
                  Padding(padding: const EdgeInsets.only(top: Dimens.s)),
                  CenterHorizontal(
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          onFormValid(context);
                        }
                      },
                      child:
                          Text(AppLocalizations.of(context).translate('save')),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void onFormValid(BuildContext context) {
    displayMessage("processing", context);
    setState(() {
      content.loading = true;
    });
    if (content.imagePath != null && content.imageUrl == null) {
      uploadImage(context);
    } else {
      postStat(context);
    }
  }

  void uploadImage(BuildContext context) {
    if (content.task != null) return;
    this.content.task = UploadImageTask(content.imagePath);
    content.task.execute().then((imageUrl) {
      this.content.imageUrl = imageUrl;
      postStat(context);
    }, onError: onError);
  }

  void postStat(BuildContext context) {
    final item = StatItem(
      userEmail: content.userEmail,
      imageUrl: content.imageUrl,
      productivity: content.productivity,
      mood: content.mood,
      comment: content.comment,
    );
    FireDb.instance.postStat(item).then((result) {
      formPosted = true;
      setState(() {
        content = StateData();
      });
    }, onError: onError);
  }

  void onError(error) {
    displayMessage('generic_error_message', context, isError: true);
  }

  void persistAndRecoverContent(BuildContext context) {
    if (content == null) {
      final content =
          PageStorage.of(context).readState(context, identifier: contentKey);
      this.content = content == null ? StateData() : content;
    } else {
      PageStorage.of(context)
          .writeState(context, content, identifier: contentKey);
    }
  }
}

class StateData {
  String imageUrl;
  String imagePath;
  String userEmail;
  String comment;
  bool loading = false;
  UploadImageTask task;
  var mood = 3.0;
  var productivity = 2.5;
}
