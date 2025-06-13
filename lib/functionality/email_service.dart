import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  Future<void> sendEmail(Uint8List rearImage, Uint8List frontImage, Position position, String toEmail) async {
    final apiKey = dotenv.env['SENDGRID_API_KEY'];
    const fromEmail = 'dsaalgorithmmanager@gmail.com';

    // ✅ Log key status (partial, safe to print)
    if (apiKey == null || apiKey.isEmpty) {
      print('[SendGrid] API key is missing or not loaded');
      throw Exception("SendGrid API key not found in .env file or is empty.");
    } else {
      print('[SendGrid] API key loaded: ${apiKey.substring(0, 5)}...');
    }

    final now = DateTime.now().toLocal();
    final locationUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    final emailContent = '''
⚠️ SOS Alert ⚠️

🧭 Location Details:
• Latitude: ${position.latitude}
• Longitude: ${position.longitude}
• Accuracy: ${position.accuracy} meters
• Time: ${now.toIso8601String()}

📍 Google Maps: $locationUrl
''';

    final body = {
      "personalizations": [
        {
          "to": [{"email": toEmail}],
          "subject": "🚨 SOS Alert - Urgent Help Required"
        }
      ],
      "from": {"email": fromEmail},
      "content": [
        {"type": "text/plain", "value": emailContent}
      ],
      "attachments": [
        {
          "content": base64Encode(rearImage),
          "type": "image/jpeg",
          "filename": "rear_image.jpg",
          "disposition": "attachment"
        },
        {
          "content": base64Encode(frontImage),
          "type": "image/jpeg",
          "filename": "front_image.jpg",
          "disposition": "attachment"
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

      print("[SendGrid] Status: ${response.statusCode}");
      if (response.statusCode != 202) {
        print("[SendGrid] Body: ${response.body}");
        throw Exception("SendGrid error: ${response.statusCode} - ${response.body}");
      } else {
        print("[SendGrid] Email sent successfully.");
      }
    } catch (e) {
      print("Email send failed: $e");
      rethrow;
    }
  }
}
