import 'dart:typed_data';
import 'package:camera/camera.dart';

class CameraService {
  Future<Uint8List?> captureImage(CameraDescription camera) async {
    CameraController controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      await Future.delayed(const Duration(milliseconds: 300));

      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();

      // Wait for autofocus-related callbacks to settle
      await Future.delayed(const Duration(milliseconds: 500));

      if (controller.value.isInitialized) {
        await controller.dispose();
      }

      return bytes;
    } catch (e) {
      print("Camera capture error: $e");
      try {
        if (controller.value.isInitialized) {
          await controller.dispose();
        }
      } catch (_) {}
      return null;
    }
  }
}
