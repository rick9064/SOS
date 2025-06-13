🚨 SOS Alert App
The SOS Alert App is a safety-focused mobile application designed to assist users in emergency situations. Built with Flutter, it captures real-time images using both front and rear cameras, retrieves live GPS location, and instantly sends an SOS email and SMS alert with all this data to a predefined contact.

✨ Features
📸 Dual Camera Capture: Takes clear photos from front and rear cameras automatically.

📍 Live Location Sharing: Fetches accurate current GPS coordinates.

📧 Email Alert: Sends an email with captured images and live location to the configured recipient.

📲 SMS Alert: Delivers a direct SMS with the same location to a specified mobile number (no message app redirection).

🗣️ Voice Feedback: Provides real-time voice updates to the user using text-to-speech (TTS).

✅ Input Validation: Ensures valid email and mobile number formats before sending.

📱 User-Friendly Interface: Simple, accessible, and responsive UI for quick access in emergencies.

🔧 Technologies Used
Flutter for cross-platform UI

Camera plugin for image capture

Location plugin for GPS

Flutter TTS for voice feedback

Permission Handler for runtime permissions

Telephony package for sending SMS

SendGrid API for sending emails with attachments


✅ Setup & Run
Clone the repo

Run flutter pub get

Ensure camera, location, and SMS permissions are configured

Connect a real device (emulator won’t support SMS/Camera APIs)

Run with flutter run