import 'package:camera/camera.dart';
import 'package:dpa/components/lifecycle_widget.dart';
import 'package:dpa/components/camera_widget.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CameraScreen extends StatefulWidget {
  static const PATH = "/camera";

  @override
  State<StatefulWidget> createState() => CameraState();
}

class CameraState extends ScreenState<CameraScreen> {
  static const String TAG = "CameraState";

  CameraState() : super(CameraScreen.PATH);

  @override
  Widget build(BuildContext context) {
    final widget = StoreConnector<AppState, CameraController>(
        converter: (store) => store.state.cameraController,
        builder: buildWithState);
    return buildWithChild(widget);
  }

  Widget buildWithState(BuildContext context, CameraController controller) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CameraPreviewWidget(controller),
          ],
        )));
  }
}
