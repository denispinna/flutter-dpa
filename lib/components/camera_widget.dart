import 'dart:async';
import 'package:dpa/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CameraWidget extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraWidget> {
  var loading = true;
  var cameraMounted = false;
  CameraController controller;

  Future<void> loadCameras()  async {
    final cameras = await availableCameras();
    final camera = CameraController(cameras[0], ResolutionPreset.medium);
    camera.initialize().then((_) {
      setState(() {
        loading = false;
        cameraMounted = mounted;
        controller = camera;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadCameras();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(loading) {
      return SpinKitWave(
          color: MyColors.second_color, type: SpinKitWaveType.start);
    } else if (!controller.value.isInitialized) {
      return Text(AppLocalizations.of(context).translate('no_camera'));
    } else {
      return AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: CameraPreview(controller));
    }
  }
}