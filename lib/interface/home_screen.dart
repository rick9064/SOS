// import 'package:flutter/material.dart';
// import '../functionality/sms_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _numberController = TextEditingController();
//   final SMSService _smsService = SMSService();

//   void _sendAlert() {
//     String number = _numberController.text.trim();
//     if (number.isNotEmpty) {
//       _smsService.sendSMS(number);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('SOS SMS sent to $number')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("SOS Alert")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _numberController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Mobile Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _sendAlert,
//               child: const Text("Send SOS Alert"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
