import 'package:telephony/telephony.dart';
import 'package:geolocator/geolocator.dart';

class SMSService {
  final Telephony _telephony = Telephony.instance;

  Future<void> sendSMS(String number, Position position, String email) async {
    try {
      final bool? granted = await _telephony.requestPhoneAndSmsPermissions;

      if (granted == null || !granted) {
        throw Exception("SMS permission not granted.");
      }

      final message = '''
🚨 SOS ALERT 🚨
Live images have been sent to the registered email: $email

Location:
https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}
''';

      await _telephony.sendSms(
        to: number,
        message: message,
        isMultipart: true,
      );
    } catch (e) {
      print("SMS Error: $e");
      rethrow;
    }
  }
}
