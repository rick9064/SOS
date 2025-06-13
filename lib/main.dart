import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'interface/sos_screen.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  try {
    // Request all necessary permissions
    await _requestPermissions();

    // Initialize cameras
    cameras = await availableCameras();
  } catch (e) {
    print("Initialization error: $e");
  }

  runApp(MyApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.location,
    Permission.sms,
    Permission.microphone,
    Permission.photos, // for iOS
    Permission.storage, // for Android 13 and below
  ].request();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (cameras == null || cameras!.length < 2) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Cameras not available"),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    final frontCamera = cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras!.first,
    );
    final rearCamera = cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras!.last,
    );

    return MaterialApp(
      home: SOSScreen(frontCamera: frontCamera, rearCamera: rearCamera),
      debugShowCheckedModeBanner: false,
    );
  }
}
