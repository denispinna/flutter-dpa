import 'package:camera/camera.dart';

class CameraProvider {
  static CameraController controller;

  static Future<CameraController> loadCamera() async {
    await disposeController();
    final cameras = await availableCameras();
    return CameraController(cameras[0], ResolutionPreset.veryHigh);
  }

  static Future disposeController() async {
    await controller?.dispose()?.catchError((e){/* Ignore */});
    controller = null;
  }
}