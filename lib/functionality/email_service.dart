import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  Future<void> sendEmail(
    Uint8List rearImage,
    Uint8List frontImage,
    Position position,
    String toEmail,
  ) async {
    final apiKey = dotenv.env['SENDGRID_API_KEY'];
    const fromEmail = 'dsaalgorithmmanager@gmail.com';

    if (apiKey == null || apiKey.isEmpty) {
      print('[SendGrid] API key missing');
      return;
    }

    final now = DateTime.now().toLocal();
    final locationUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    final body = {
      "personalizations": [
        {
          "to": [{"email": toEmail}],
          "subject": "🚨 SOS Report - ${now.toIso8601String()}"
        }
      ],
      "from": {"email": fromEmail},
      "content": [
        {
          "type": "text/plain",
          "value": '''
⚠️ SOS Alert (Live Feed)

🧭 Location:
• Latitude: ${position.latitude}
• Longitude: ${position.longitude}
• Accuracy: ${position.accuracy}m
• Time: ${now.toIso8601String()}

📍 Google Maps: $locationUrl
'''
        }
      ],
      "attachments": [
        {
          "content": base64Encode(rearImage),
          "type": "image/jpeg",
          "filename": "rear_image.jpg"
        },
        {
          "content": base64Encode(frontImage),
          "type": "image/jpeg",
          "filename": "front_image.jpg"
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse("https://api.sendgrid.com/v3/mail/send"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 202) {
        print("[SendGrid] Email sent at $now");
      } else {
        print("[SendGrid] Failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("[SendGrid] Exception: $e");
    }
  }
}
