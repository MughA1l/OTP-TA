import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

/// Serverless FCM V1 Push Notification Service
/// Sends push notifications directly from the Flutter client using Google APIs.
/// WARNING: Requires embedding the Service Account JSON in the app.
class FcmClientService {
  // TODO: Replace with your actual Firebase Project ID
  static const String _projectId = 'otpta-app';
  static const String _fcmUrl = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  // TODO: Paste the contents of your downloaded Service Account JSON here.
  // DO NOT commit this file to public repositories.
  static const Map<String, dynamic> _serviceAccountJson = {
    "type": "service_account",
    "project_id": "otpta-app",
    "private_key_id": "YOUR_PRIVATE_KEY_ID",
    "private_key": "YOUR_PRIVATE_KEY",
    "client_email": "YOUR_CLIENT_EMAIL",
    "client_id": "YOUR_CLIENT_ID",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "YOUR_CERT_URL"
  };

  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  /// Generates an OAuth2 token using the embedded service account
  static Future<String?> _getAccessToken() async {
    try {
      final accountCredentials = ServiceAccountCredentials.fromJson(_serviceAccountJson);
      final client = await clientViaServiceAccount(accountCredentials, _scopes);
      final accessToken = client.credentials.accessToken.data;
      client.close();
      return accessToken;
    } catch (e) {
      print('Error getting FCM Access Token: $e');
      return null;
    }
  }

  /// Sends a push notification to a specific device token
  static Future<bool> sendPushMessage({
    required String targetFcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final token = await _getAccessToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': {
            'token': targetFcmToken,
            'notification': {
              'title': title,
              'body': body,
            },
            if (data != null) 'data': data,
            'android': {
              'priority': 'high',
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        print('FCM Sent successfully');
        return true;
      } else {
        print('FCM Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('FCM Exception: $e');
      return false;
    }
  }
}
