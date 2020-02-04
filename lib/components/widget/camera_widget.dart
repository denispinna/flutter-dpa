import 'dart:io';
import 'dart:ui';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:dpa/provider/camera_provider.dart';
import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

const IMAGE_RATIO = 16 / 9;

class TakePictureWidget extends StatefulWidget {
  final CameraController controller;

  const TakePictureWidget(this.controller);

  @override
  State<StatefulWidget> createState() => TakePictureState(controller);
}

class TakePictureState extends State<TakePictureWidget> {
  final CameraController controller;
  String imagePath;

  TakePictureState(this.controller);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
        converter: (store) => store.state.imagePath,
        builder: (context, imagePath) {
          if (imagePath == null) {
            return BlurryCameraPreview();
          } else {
            this.imagePath = imagePath;
            return StoreConnector<AppState, Function>(
                converter: (store) =>
                    () => store.dispatch(PictureTakenAction(null)),
                builder: (context, clearPicture) {
                  return Stack(
                    children: <Widget>[
                      AspectRatio(
                          aspectRatio: IMAGE_RATIO,
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                          child: new Align(
                        alignment: FractionalOffset.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.xs),
                          child: Container(
                              decoration: new BoxDecoration(
                                  color: MyColors.alpha_red,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(40.0))),
                              child: GestureDetector(
                                child: Padding(
                                    padding: const EdgeInsets.all(Dimens.xs),
                                    child: SvgPicture.asset(MyImages.cross,
                                        height: Dimens.picto_button_width,
                                        width: Dimens.picto_button_width,
                                        color: Colors.white)),
                                onTap: clearPicture,
                              )),
                        ),
                      )),
                    ],
                  );
                });
          }
        });
  }
}

class CameraPreviewWidget extends StatefulWidget {

  @override
  CameraState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends CameraState {
  static const TAG = "CameraPreviewWidget";

  Widget buildCameraWidget(BuildContext context) {
    return StoreConnector<AppState, Function(String)>(
        converter: (store) =>
            (imagePath) => store.dispatch(PictureTakenAction(imagePath)),
        builder: (context, dispatchPicture) {
          return buildWithDispatchFunction(context, dispatchPicture);
        });
  }

  Widget buildWithDispatchFunction(
      BuildContext context, Function(String) dispatchPicture) {
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
                    child: GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.all(Dimens.xs),
                          child: SvgPicture.asset(MyImages.take_picture,
                              height: Dimens.large_picto_button_width,
                              width: Dimens.large_picto_button_width,
                              color: MyColors.second)),
                      onTap: () => takePicture(dispatchPicture),
                    )),
              ),
            )),
          ],
        ));
  }

  Future takePicture(Function(String) dispatchPicture) async {
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
      dispatchPicture(null);
    }
    return dispatchPicture(filePath);
  }
}

class BlurryCameraPreview extends StatefulWidget {

  @override
  CameraState createState() => BlurryCameraPreviewState();
}

class BlurryCameraPreviewState extends CameraState {
  CameraController controller;

  Widget buildCameraWidget(BuildContext context) {
    return StoreConnector<AppState, Function>(
        converter: (store) => () => store.dispatch(
            RouteAction(destination: "/camera", type: RouteActionType.Push)),
        builder: buildWithState);
  }

  Widget buildWithState(BuildContext context, Function openCamera) {
    return GestureDetector(
      child: AspectRatio(
          aspectRatio: IMAGE_RATIO,
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

abstract class CameraState extends LifecycleWidgetState<StatefulWidget> {
  CameraController controller;

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
  void onPause() {}

  @override
  void onResume() {
    initializeCamera();
  }

  Future initializeCamera() async {
    if (controller == null) {

      controller = await CameraProvider.loadCamera();
      await controller.initialize();
      setState(() {
        controller = controller;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null)
      return buildCameraWidget(context);
    else
      return buildLoadingWidget();
  }


  Widget buildLoadingWidget() {
    return AspectRatio(
        aspectRatio: IMAGE_RATIO,
        child: Stack(children: <Widget>[
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(0.2))),
            ),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.l),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
                ),
              )),
        ]));
  }

  Widget buildCameraWidget(BuildContext context);

}
