import 'dart:collection';

import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/file_manager.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/components/widget/connected_widget.dart';
import 'package:dpa/components/widget/loading_widget.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class InputStat extends StatefulWidget {
  InputStat({Key key}) : super(key: key);

  @override
  InputItemState createState() => InputItemState();
}

class InputItemState
    extends CustomStoreConnectedState<InputStat, List<StatItem>> {
  static final contentKey = ValueKey('InputItemState');
  TakePictureWidget takePictureWidget;
  StateData content;
  bool formPosted = false;

  @override
  Widget buildWithStore(BuildContext context, List<StatItem> statItems) {
    persistAndRecoverContent(context);
    if (content.loading || statItems.length == 0) {
      return LoadingWidget(
        showLabel: false,
      );
    } else if (formPosted) {
      Future.delayed(Duration(milliseconds: 200),
          () => displayMessage('post_stat_success', context, isSuccess: true));
      formPosted = false;
    }
    return buildInputForm(context, statItems);
  }

  Widget buildInputForm(BuildContext context, List<StatItem> statItems) {
    List<Widget> inputWidgets = List();
    inputWidgets
        .add(Padding(padding: const EdgeInsets.only(top: Dimens.padding_l)));
    for (final item in statItems) {
      inputWidgets.add(item.getInputWidget(
        context: context,
        onValueChanged: (value) =>
            onValueChanged(key: item.key, value: value, context: context),
        initialValue: content.stats[item.key],
      ));
      inputWidgets
          .add(Padding(padding: const EdgeInsets.only(top: Dimens.padding_m)));
    }
    inputWidgets.add(CenterHorizontal(
      RaisedButton(
        color: MyColors.white,
        onPressed: () {
          //TODO: Add check on components (something has been done)
          onFormValid(context);
        },
        child: Text(AppLocalizations.of(context).translate('save')),
      ),
    ));
    return SingleChildScrollView(
      child: Column(
        children: inputWidgets,
      ),
    );
  }

  @override
  List<StatItem> converter(Store store) => store.state.statItems;

  void onFormValid(BuildContext context) {
    setState(() {
      content.loading = true;
    });
    final imagePath = content.stats[DefaultStatItem.default_picture.label];
    if (imagePath != null && content.imageUrl == null) {
      uploadImage(context, imagePath);
    } else {
      postStat(context);
    }
  }

  void uploadImage(BuildContext context, String imagePath) {
    if (content.task != null) return;
    this.content.task = UploadImageTask(imagePath);
    content.task.execute().then((imageUrl) {
      this.content.imageUrl = imageUrl;
      postStat(context);
    }, onError: onError);
  }

  void postStat(BuildContext context) {
    final item = StatEntry(
      date: DateTime.now(),
      stats: content.stats,
    );
    // We replace the image path by the imageUrl
    if (content.imageUrl != null)
      content.stats[DefaultStatItem.default_picture.label] = content.imageUrl;

    API.statApi.postStatEntry(item).then((result) {
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

  onValueChanged({
    @required String key,
    @required Object value,
    @required BuildContext context,
  }) {
    content.stats[key] = value;
    persistAndRecoverContent(context);
  }
}

class StateData {
  String imageUrl;
  bool loading = false;
  UploadImageTask task;
  HashMap<String, dynamic> stats = HashMap();
}
