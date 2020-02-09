import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/image_preview.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:dpa/provider/camera_provider.dart';
import 'package:dpa/screens/camera/camera_screen.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

const IMAGE_RATIO = 16 / 9;

class TakePictureWidget extends StatefulWidget {
  final bool liveButton;

  const TakePictureWidget({this.liveButton = false});

  @override
  State<StatefulWidget> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePictureWidget> {
  String imagePath;

  @override
  Widget build(BuildContext context) {
    this.imagePath = imagePath;
    if (imagePath == null) {
      if (widget.liveButton)
        return CameraWidgetWithPreview(
          onPictureTaken: onPictureTaken,
        );
      else {
        return CameraWidget(onPictureTaken);
      }
    } else {
      return GestureDetector(
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: IMAGE_RATIO,
              child: ImagePreview(
                fromFile: true,
                pathOrUrl: imagePath,
                ratio: IMAGE_RATIO,
              ),
            ),
            Positioned(
                child: new Align(
              alignment: FractionalOffset.topRight,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.xs),
                child: Container(
                    decoration: new BoxDecoration(
                        color: MyColors.alpha_red,
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(40.0))),
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
        ),
      );
    }
  }

  void clearPicture() {
    setState(() {
      imagePath = null;
    });
  }

  void onPictureTaken(String path) {
    setState(() {
      imagePath = path;
    });
  }
}

class CameraWidget extends StatelessWidget {
  final Function(String path) onPictureTaken;

  CameraWidget(this.onPictureTaken);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: IMAGE_RATIO,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: MyImages.sunset_background,
                  fit: BoxFit.cover,
                ),
              ),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
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
        ),
      ),
      onTap: () => Navigator.pushNamed(context, CameraScreen.PATH,
          arguments: onPictureTaken),
    );
  }
}

class CameraPreviewWidget extends StatefulWidget {
  final Function(String) onPictureTaken;

  const CameraPreviewWidget(this.onPictureTaken);

  @override
  CameraState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends CameraState<CameraPreviewWidget> {
  static const TAG = "CameraPreviewWidget";

  Widget buildCameraWidget(BuildContext context) {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(_controller),
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
                      onTap: () => takePicture(context),
                    )),
              ),
            )),
          ],
        ));
  }

  Future takePicture(BuildContext context) async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/dpa';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      Logger.logError(TAG, "error on taking picture", e);
    }
    widget.onPictureTaken(filePath);
    Navigator.pop(context);
  }
}

class CameraWidgetWithPreview extends StatefulWidget {
  final Function(String) onPictureTaken;

  const CameraWidgetWithPreview({@required this.onPictureTaken});

  @override
  _CameraWidgetWithPreviewState createState() =>
      _CameraWidgetWithPreviewState();
}

class _CameraWidgetWithPreviewState
    extends CameraState<CameraWidgetWithPreview> {
  @override
  Widget buildCameraWidget(BuildContext context) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: IMAGE_RATIO,
        child: Stack(
          children: <Widget>[
            if (_controller != null && _controller.value.isInitialized)
              buildCameraPreview()
            else
              buildCameraPlaceholder(),
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
        ),
      ),
      onTap: () => Navigator.pushNamed(
        context,
        CameraScreen.PATH,
        arguments: widget.onPictureTaken,
      ),
    );
  }

  Widget buildCameraPreview() {
    return ListView(
      children: <Widget>[
        AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller)),
      ],
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget buildCameraPlaceholder() {
    return Container(
      color: Colors.grey,
    );
  }
}

abstract class CameraState<W extends StatefulWidget>
    extends LifecycleWidgetState<W> {
  bool isInitializing = false;
  CameraController _controller;

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  void onResume() {
    _initializeCamera();
  }

  Future<CameraController> _initializeCamera() async {
    if (_controller == null) {
      _controller = await CameraProvider.instance.loadCamera();
    }
    if (!_controller.value.isInitialized) {
      await _controller.initialize();
    }
    return _controller;
  }

  @override
  Widget buildWithLifecycle(BuildContext context) {
    return FutureBuilder<CameraController>(
      future: _initializeCamera(),
      builder: (context, snapshot) {
        return (snapshot.data != null)
            ? buildCameraWidget(context)
            : buildLoadingWidget();
      },
    );
  }

  Widget buildLoadingWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.l),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
        ),
      ),
    );
  }

  Widget buildCameraWidget(BuildContext context);

  Future disposeController() async {
    _controller?.dispose();
    _controller = null;
  }
}
