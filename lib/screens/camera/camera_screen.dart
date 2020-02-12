import 'package:dpa/widget/base/lifecycle_widget.dart';
import 'package:dpa/widget/camera_widget.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  static const PATH = "/camera";

  @override
  State<StatefulWidget> createState() => _CameraState();
}

class _CameraState extends ScreenState<CameraScreen> {
  static const String TAG = "CameraState";

  @override
  Widget buildScreenWidget(BuildContext context) {
    final Function(String) onPictureTaken =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CameraPreviewWidget(onPictureTaken),
          ],
        )));
  }
}
