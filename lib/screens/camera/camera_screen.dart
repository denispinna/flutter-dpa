import 'package:dpa/components/widget/connected_widget.dart';
import 'package:dpa/components/widget/camera_widget.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  static const PATH = "/camera";

  @override
  State<StatefulWidget> createState() => CameraState();
}

class CameraState extends ScreenState<CameraScreen> {
  static const String TAG = "CameraState";

  CameraState() : super(CameraScreen.PATH);

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                CameraPreviewWidget(),
              ],
            )));
  }
}
