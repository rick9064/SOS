import 'dart:async';
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

  Timer? _emailTimer;
  bool _isRunning = false;

  Future<void> triggerSOS({
    required CameraDescription frontCamera,
    required CameraDescription rearCamera,
    required String email,
    required String mobile,
  }) async {
    // First run immediately
    await _runCaptureAndSend(frontCamera, rearCamera, email, mobile, true);

    // Start repeating every 30 seconds
    _emailTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!_isRunning) {
        _runCaptureAndSend(frontCamera, rearCamera, email, mobile, false);
      }
    });
  }

  Future<void> _runCaptureAndSend(
    CameraDescription frontCamera,
    CameraDescription rearCamera,
    String email,
    String mobile,
    bool isInitial,
  ) async {
    _isRunning = true;

    try {
      print("[SOS] Capturing rear image...");
      final rearImage = await _cameraService.captureImage(rearCamera);

      print("[SOS] Capturing front image...");
      final frontImage = await _cameraService.captureImage(frontCamera);

      print("[SOS] Getting location...");
      final location = await _locationService.getCurrentLocation();

      if (rearImage != null && frontImage != null && location != null) {
        print("[SOS] Sending email...");
        await _emailService.sendEmail(rearImage, frontImage, location, email);

        if (isInitial) {
          print("[SOS] Sending SMS...");
          await _smsService.sendSMS(mobile, location, email);
        }
      } else {
        print("[SOS] Skipping due to null image/location.");
      }
    } catch (e) {
      print("[SOSService] Error during SOS: $e");
    } finally {
      _isRunning = false;
    }
  }

  void stopSOS() {
    _emailTimer?.cancel();
    _emailTimer = null;
    print("[SOSService] SOS stopped.");
  }
}
