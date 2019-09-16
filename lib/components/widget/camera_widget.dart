import 'dart:io';
import 'dart:ui';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            return BlurryCameraPreview(controller, (imagePath) {
              setState(() {
                this.imagePath = imagePath;
              });
            });
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

class CameraPreviewWidget extends CameraWidget {
  static const TAG = "CameraPreviewWidget";
  final CameraController controller;

  const CameraPreviewWidget(this.controller) : super(controller);

  @override
  CameraState createState() => CameraState(this);

  @override
  Widget build(BuildContext context) {
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
                              color: MyColors.second_color)),
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

class BlurryCameraPreview extends CameraWidget {
  final CameraController controller;
  final Function(String) updateImagePath;

  const BlurryCameraPreview(this.controller, this.updateImagePath)
      : super(controller);

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
          aspectRatio: IMAGE_RATIO,
          child: Stack(
            children: <Widget>[
              ListView(children: <Widget>[
                AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller))
              ], physics: const NeverScrollableScrollPhysics()),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, Dimens.padding_xl, 0, 0),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade600.withOpacity(0.2))),
                    ),
                  )),
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
  static var initialized = false;
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
  void onPause() {}

  @override
  void onResume() {
    initializeCamera();
  }

  Future initializeCamera() async {
    if (!initialized) {
      await controller.initialize();
      setState(() {
        initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialized)
      return widget.build(context);
    else
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
              child: SpinKitWave(
                  color: MyColors.second_color, type: SpinKitWaveType.start),
            )),
          ]));
  }
}

abstract class CameraWidget extends StatefulWidget {
  final CameraController controller;

  const CameraWidget(this.controller);

  Widget build(BuildContext context);
}
