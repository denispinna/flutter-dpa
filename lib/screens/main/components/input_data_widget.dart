import 'package:dpa/components/file_manager.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/connected_widget.dart';
import 'package:dpa/components/widget/loading_widget.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/api.dart';
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
    if (content.loading) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(Dimens.l),
        child: LoadingWidget(
          showLabel: false,
          label: 'processing',
        ),
      ));
    } else if (formPosted) {
      displayMessage('post_stat_success', context, isSuccess: true);
      formPosted = false;
    }
    return buildInputForm(context, statItems);
  }

  Widget buildInputForm(BuildContext context, List<StatItem> statItems) {
    return Column();
  }

  @override
  List<StatItem> converter(Store store) => store.state.statItems;

  void onFormValid(BuildContext context) {
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
    final item = DateStatEntry(
      userEmail: content.userEmail,
      imageUrl: content.imageUrl,
      productivity: content.productivity,
      mood: content.mood,
      comment: content.comment,
    );
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
