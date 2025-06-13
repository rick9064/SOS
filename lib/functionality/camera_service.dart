import 'dart:typed_data';
import 'package:camera/camera.dart';

class CameraService {
Future<Uint8List?> captureImage(CameraController controller) async {
  try {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return null;
    }

    await Future.delayed(const Duration(milliseconds: 300)); // Short autofocus delay
    final image = await controller.takePicture();
    return await image.readAsBytes();
  } catch (e) {
    print("Camera capture error: $e");
    return null;
  }
}

}
