import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serverless Email Service using EmailJS REST API
class EmailService {
  // TODO: Create a free account at EmailJS.com and fill these keys
  static const String _serviceId = 'YOUR_SERVICE_ID';
  static const String _templateId = 'YOUR_TEMPLATE_ID';
  static const String _userId = 'YOUR_PUBLIC_KEY'; // Called "Public Key" in EmailJS
  
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends login credentials to the patient directly from the Flutter app
  static Future<bool> sendCredentialsEmail({
    required String patientEmail,
    required String patientName,
    required String tempPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _userId,
          'template_params': {
            'to_email': patientEmail,
            'to_name': patientName,
            'temp_password': tempPassword,
            'message': 'Your operation has been scheduled. You can now log into the patient portal to track your status, view medications, and communicate with your surgical team. Please change your password within 24 hours.'
          }
        }),
      );

      if (response.statusCode == 200) {
        print('EmailJS: Email sent successfully');
        return true;
      } else {
        print('EmailJS Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('EmailJS Exception: $e');
      return false;
    }
  }
}
