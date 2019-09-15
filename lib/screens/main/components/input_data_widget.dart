import 'package:camera/camera.dart';
import 'package:dpa/components/camera_widget.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InputDataWidget extends StatefulWidget {
  final authApi = AuthAPI.instance;

  @override
  InputDataState createState() => InputDataState(this);
}

class InputDataState extends State<InputDataWidget> {
  static const String TAG = "HomeState";
  InputDataWidget widget;

  InputDataState(this.widget);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraController>(
      converter: (store) => store.state.cameraController,
      builder: (context, controller) {
        return ListView(shrinkWrap: true, children: <Widget>[
          BlurryCameraPreview(controller),
        ]);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
