import 'dart:io';
import 'dart:ui';
import 'package:dpa/app_localization.dart';
import 'package:dpa/components/back_pop_widget.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/util/logger.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class CameraPreviewWidget extends CameraWidget {
  static const TAG = "CameraPreviewWidget";
  final CameraController controller;

  const CameraPreviewWidget(this.controller) : super(controller);

  @override
  CameraState createState() => CameraState(this);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            Positioned(
                child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(Dimens.l),
                  child: Container(
                    decoration: new BoxDecoration(
                        color: MyColors.alpha_white,
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(40.0))),
                    child: Padding(
                        padding: const EdgeInsets.all(Dimens.xs),
                        child: SvgPicture.asset(MyImages.take_picture,
                            height: Dimens.picto_button_width,
                            width: Dimens.picto_button_width,
                            color: MyColors.second_color)),
                  )),
            )),
          ],
        ));
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      Logger.logError(TAG, "error on taking picture", e);
      return null;
    }
    return filePath;
  }
}

class BlurryCameraPreview extends CameraWidget {
  final CameraController controller;

  const BlurryCameraPreview(this.controller) : super(controller);

  @override
  CameraState createState() => CameraState(this);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
        converter: (store) => () => store.dispatch(
            RouteAction(destination: "/camera", type: RouteActionType.Push)),
        builder: buildWithState);
  }

  Widget buildWithState(BuildContext context, Function openCamera) {
    return GestureDetector(
      child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: <Widget>[
              ListView(children: <Widget>[
                AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller))
              ], physics: const NeverScrollableScrollPhysics()),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(0.2))),
                ),
              ),
              Center(
                  child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Image(
                            image: MyImages.camera,
                            height: Dimens.picture_preview_button_width),
                        Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate('take_photo'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.font_m,
                                )))
                      ],
                      physics: const NeverScrollableScrollPhysics()))
            ],
          )),
      onTap: openCamera,
    );
  }
}

class CameraState extends LifecycleWidgetState<CameraWidget> {
  var initialized = false;
  final CameraWidget widget;
  CameraController controller;

  CameraState(this.widget) {
    this.controller = widget.controller;
  }

  @override
  void dispose() {
    onPause();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onResume();
  }

  @override
  void onPause() {
//    if (initialized) {
//      controller?.dispose();
//      try {
//        setState(() {
//          initialized = false;
//        });
//      } catch (e) {}
//    }
  }

  @override
  void onResume() {
    initializeCamera();
  }

  void initializeCamera() async {
    if (!initialized) {
      controller.initialize().then((_) {
        setState(() {
          initialized = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialized)
      return widget.build(context);
    else
      return SpinKitWave(
          color: MyColors.second_color, type: SpinKitWaveType.start);
  }
}

abstract class CameraWidget extends StatefulWidget {
  final CameraController controller;

  const CameraWidget(this.controller);

  Widget build(BuildContext context);
}
