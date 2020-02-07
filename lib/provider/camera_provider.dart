import 'package:camera/camera.dart';

class CameraProvider {
  static CameraProvider instance = CameraProvider();
  CameraDescription _cameraDescription;

  Future<CameraController> loadCamera() async {
    if (_cameraDescription == null)
      _cameraDescription = (await availableCameras()).first;

    return CameraController(_cameraDescription, ResolutionPreset.veryHigh);
  }
}
