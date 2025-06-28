import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../functionality/sos_service.dart';

class SOSScreen extends StatefulWidget {
  final CameraDescription frontCamera;
  final CameraDescription rearCamera;

  const SOSScreen({super.key, required this.frontCamera, required this.rearCamera});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final SOSService _sosService = SOSService();
  final FlutterTts _flutterTts = FlutterTts();

  bool isSending = false;
  bool _isDisposed = false;
  bool sosActive = false;

  Future<void> _speak(String message) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(message);
  }

  Future<void> _startSOS() async {
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();

    if (!email.contains('@') || mobile.length != 10) {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email and 10-digit mobile number')),
        );
        _speak("Please enter a valid email and mobile number.");
      }
      return;
    }

    setState(() => isSending = true);

    try {
      await _sosService.triggerSOS(
        frontCamera: widget.frontCamera,
        rearCamera: widget.rearCamera,
        email: email,
        mobile: '+91$mobile',
      );
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS started with email and SMS')),
        );
        _speak("SOS started with email and SMS.");
        setState(() => sosActive = true);
      }
    } catch (e) {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        _speak("Failed to start SOS.");
      }
    } finally {
      if (!_isDisposed) {
        setState(() => isSending = false);
      }
    }
  }

  void _stopSOS() {
    _sosService.stopSOS();
    setState(() => sosActive = false);
    _speak("SOS stopped.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS stopped')),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _flutterTts.stop();
    _sosService.stopSOS();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS Email + SMS')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Recipient Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number (10-digit)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSending || sosActive ? null : _startSOS,
                    child: isSending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Start SOS'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: sosActive ? _stopSOS : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Stop SOS'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
