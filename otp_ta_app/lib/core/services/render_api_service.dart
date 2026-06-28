import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';

class RenderApiService {
  static const String _baseUrl = AppConfig.backendBaseUrl;

  /// Calls `POST /api/notify/single` to send FCM push notification to a patient (SRS-100)
  static Future<bool> sendOperationStatusNotification({
    required String fcmToken,
    required String title,
    required String body,
    required String operationId,
    required String newStatus,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/notify/single'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': fcmToken,
          'title': title,
          'body': body,
          'data': {
            'operationId': operationId,
            'status': newStatus,
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('RenderApiService.sendOperationStatusNotification Error: $e');
      return false;
    }
  }

  /// Calls `POST /api/email/credentials` to email credentials using Resend API (SRS-73, SRS-74)
  static Future<bool> sendPatientCredentials({
    required String email,
    required String name,
    required String temporaryPassword,
    required String deepLink,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/email/credentials'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'name': name,
          'temporaryPassword': temporaryPassword,
          'deepLink': deepLink,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('RenderApiService.sendPatientCredentials Error: $e');
      return false;
    }
  }

  /// Calls `POST /api/notify/emergency` on Render.com server with list of team member FCM tokens (SRS-92)
  static Future<bool> sendEmergencyAlert({
    required List<String> fcmTokens,
    required String roomId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/notify/emergency'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tokens': fcmTokens,
          'roomId': roomId,
          'message': message,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('RenderApiService.sendEmergencyAlert Error: $e');
      return false;
    }
  }
}
