import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/components/widget/image_preview.dart';
import 'package:dpa/components/widget/mood_widget.dart';
import 'package:dpa/components/widget/pructivity_widget.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/productivity.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

List<StatItem> getDefaultStatItems(String userEmail) {
  String userEmail = AuthAPI.instance.user.email;
  List<StatItem> defaultItems = List();
  defaultItems.add(PictureStatItem(userEmail: userEmail));
  defaultItems.add(MoodStatItem(userEmail: userEmail));
  defaultItems.add(ProductivityStatItem(userEmail: userEmail));
  defaultItems.add(CommentStatItem(userEmail: userEmail));
  return defaultItems;
}

class PictureStatItem extends TextStatItem {
  const PictureStatItem({@required userEmail})
      : super(
          userEmail: userEmail,
          isCustom: false,
          isEnabled: true,
          key: 'default_picture',
          inputLabel: null,
          outputLabel: '',
          localizedLabel: true,
          color: MyColors.dark,
          maxLength: null,
          position: 0,
          displayInList: false,
        );

  @override
  Widget getInputWidget(BuildContext context, String initialValue,
      Function(String) onValueChanged) {
    return TakePictureWidget(onPictureTaken: onValueChanged);
  }

  @override
  Widget getOutputDetailWidget(BuildContext context, String value) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
          child: ImagePreview(pathOrUrl: value)),
    );
  }

  @override
  Widget getOutputListWidget(BuildContext context, String value) {
    return null;
  }
}

class MoodStatItem extends QuantityStatItem {
  const MoodStatItem({@required userEmail})
      : super(
          userEmail: userEmail,
          isCustom: false,
          isEnabled: true,
          key: 'default_mood',
          inputLabel: 'mood_label',
          outputLabel: '',
          localizedLabel: true,
          color: MyColors.dark,
          min: 1,
          max: 5,
          position: 1,
          displayInList: true,
        );

  @override
  Widget getInputWidget(
      BuildContext context, double initialValue, Function(double) onValueChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CenterHorizontal(Text(
          AppLocalizations.of(context).translate(inputLabel),
          style: TextStyle(color: MyColors.dark, fontSize: Dimens.title_font),
        )),
        Padding(padding: const EdgeInsets.only(top: Dimens.padding_s)),
        CenterHorizontal(RatingBar(
          initialRating: initialValue.toDouble(),
          itemCount: 5,
          itemSize: Dimens.input_rating_icon_width,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.xxxs),
              child: Mood.values[index].icon,
            );
          },
          minRating: min.toDouble(),
          onRatingUpdate: (rating) => onValueChanged(rating),
        ))
      ],
    );
  }

  @override
  Widget getOutputDetailWidget(BuildContext context, double value) {
    final mood = Mood.values[value.toInt() - 1];

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            mood.icon,
            SizedBox(width: Dimens.s),
            MoodLabel(mood)
          ],
        ),
      ),
    );
  }

  @override
  Widget getOutputListWidget(BuildContext context, double value) {
    Mood mood = Mood.values[value.toInt() - 1];
    return MoodLabel(mood);
  }
}

class ProductivityStatItem extends QuantityStatItem {
  double _productivity;

  ProductivityStatItem({@required userEmail})
      : super(
          userEmail: userEmail,
          isCustom: false,
          isEnabled: true,
          key: 'default_productivity',
          inputLabel: 'productivity_label',
          outputLabel: '',
          localizedLabel: true,
          color: MyColors.dark,
          min: 0,
          max: 5,
          position: 2,
          displayInList: true,
        );

  @override
  Widget getInputWidget(BuildContext context, double initialValue,
      Function(double) onValueChanged) {
    return Column(
      children: <Widget>[
        CenterHorizontal(Text(
          AppLocalizations.of(context).translate(inputLabel),
          style: TextStyle(color: MyColors.dark, fontSize: Dimens.title_font),
        )),
        Padding(padding: const EdgeInsets.only(top: Dimens.padding_s)),
        CenterHorizontal(RatingBar(
          initialRating: initialValue,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: Dimens.input_rating_icon_width,
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: (index + 1).getProductivityIcon(
                filled: false,
                color: _productivity.productivityColor,
              )),
          onRatingUpdate: (rating) {
            _productivity = rating;
            onValueChanged(rating);
          },
        ))
      ],
    );
  }

  @override
  Widget getOutputDetailWidget(BuildContext context, double value) {
    return ProductivityDetailWidget(value);
  }

  @override
  Widget getOutputListWidget(BuildContext context, double value) {
    return ProductivityListWidget(value);
  }
}

class CommentStatItem extends TextStatItem {
  const CommentStatItem({@required userEmail})
      : super(
          userEmail: userEmail,
          isCustom: false,
          isEnabled: true,
          key: 'default_comment',
          inputLabel: 'comment_hint',
          outputLabel: '',
          localizedLabel: true,
          color: MyColors.dark,
          maxLength: 1000,
          position: 3,
          displayInList: false,
        );

  @override
  Widget getInputWidget(BuildContext context, String initialValue,
      Function(String) onValueChanged) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.padding_xxxl),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          initialValue: initialValue,
          minLines: 3,
          maxLines: 3,
          maxLength: maxLength,
          onChanged: onValueChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate(inputLabel),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MyColors.light_gray,
                width: 1.0,
              ),
            ),
            border: const OutlineInputBorder(),
          ),
        ));
  }

  @override
  Widget getOutputDetailWidget(BuildContext context, String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: Dimens.font_ml,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget getOutputListWidget(BuildContext context, String value) {
    return null;
  }
}
