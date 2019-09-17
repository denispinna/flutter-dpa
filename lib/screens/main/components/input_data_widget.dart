import 'package:camera/camera.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/file_manager.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InputDataWidget extends StatefulWidget {
  final authApi = AuthAPI.instance;

  @override
  InputDataState createState() => InputDataState(this);
}

class InputDataState extends State<InputDataWidget> {
  static const String TAG = "InputDataState";
  InputDataWidget widget;
  final _formKey = GlobalKey<FormState>();
  String imageUrl;
  String imagePath;
  String userEmail;
  bool loading = false;
  UploadImageTask task;

  InputDataState(this.widget);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(Dimens.l),
        child: SpinKitCubeGrid(color: MyColors.second_color),
      ));
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
    }
    return StoreConnector<AppState, CameraController>(
      converter: (store) {
        final state = store.state;
        if (imagePath != state.imagePath) imagePath = state.imagePath;
        if (userEmail == null) userEmail = state.user.email;

        return state.cameraController;
      },
      builder: (context, controller) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.padding_xxxl,
              Dimens.padding_xxxxl,
              Dimens.padding_xxxl,
              Dimens.padding_xxxl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TakePictureWidget(controller),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.padding_m),
                    child: CenterHorizontal(RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          onFormValid(context);
                        }
                      },
                      child:
                          Text(AppLocalizations.of(context).translate('save')),
                    )),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void onFormValid(BuildContext context) {
    displayMessage("processing", context);
    if (imagePath != null && imageUrl == null) {
      uploadImage(context);
    } else {
      postStat(context);
    }
  }

  void uploadImage(BuildContext context) {
    if (task != null) return;
    setState(() {
      loading = true;
    });
    this.task = UploadImageTask(imagePath);
    task.execute((imageUrl) {
      this.imageUrl = imageUrl;
      postStat(context);
    });
  }

  void postStat(BuildContext context) {
    final item = StatItem(userEmail: userEmail, imageUrl: imageUrl);
    FireDbComponent.instance.postStat(item);
    setState(() {
      loading = false;
    });
  }
}
