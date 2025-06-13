import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'camera_service.dart';
import 'location_service.dart';
import 'email_service.dart';
import 'sms_service.dart';

class SOSService {
  final CameraService _cameraService = CameraService();
  final LocationService _locationService = LocationService();
  final EmailService _emailService = EmailService();
  final SMSService _smsService = SMSService();

  Future<void> triggerSOS({
    required CameraDescription frontCamera,
    required CameraDescription rearCamera,
    required String email,
    required String mobile,
  }) async {
    CameraController? rearController;
    CameraController? frontController;

    try {
      // Initialize and capture from rear camera
      rearController = CameraController(rearCamera, ResolutionPreset.high);
      await rearController.initialize();
      final rearImage = await _cameraService.captureImage(rearController);

      // Small delay to ensure channel reply is done before disposing
      await Future.delayed(const Duration(milliseconds: 300));
      await rearController.dispose();
      rearController = null;

      // Initialize and capture from front camera
      frontController = CameraController(frontCamera, ResolutionPreset.high);
      await frontController.initialize();
      final frontImage = await _cameraService.captureImage(frontController);

      await Future.delayed(const Duration(milliseconds: 300));
      await frontController.dispose();
      frontController = null;

      // Get location
      final location = await _locationService.getCurrentLocation();

      // Send email and SMS
      if (frontImage != null && rearImage != null && location != null) {
        await _emailService.sendEmail(rearImage, frontImage, location, email);
        await _smsService.sendSMS(mobile, location, email);
      } else {
        throw Exception('Missing image or location');
      }

    } catch (e) {
      // Dispose controllers safely
      if (rearController != null && rearController.value.isInitialized) {
        await rearController.dispose();
      }
      if (frontController != null && frontController.value.isInitialized) {
        await frontController.dispose();
      }
      rethrow;
    }
  }
}
