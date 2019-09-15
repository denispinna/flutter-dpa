import 'package:camera/camera.dart';

class CameraProvider {
  static Future<CameraController> loadCamera() async {
    final cameras = await availableCameras();
    return CameraController(cameras[0], ResolutionPreset.veryHigh);
  }
}