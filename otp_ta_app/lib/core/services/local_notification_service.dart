import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Serverless Local Notification Service
/// Handles scheduling of checkup and operation reminders locally.
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Update with your app icon

    // iOS Initialization
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  /// Schedules a reminder notification for a specific date and time
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'otpta_reminders',
          'Appointment Reminders',
          channelDescription: 'Notifications for upcoming appointments and surgeries',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Convenience method to schedule 24h and 2h reminders for an appointment
  static Future<void> scheduleAppointmentReminders({
    required String operationId,
    required DateTime appointmentDate,
    required String doctorName,
  }) async {
    // 24 hours before
    final twentyFourHoursBefore = appointmentDate.subtract(const Duration(hours: 24));
    if (twentyFourHoursBefore.isAfter(DateTime.now())) {
      await scheduleReminder(
        id: operationId.hashCode, // Unique ID based on operationId
        title: 'Upcoming Surgery Reminder',
        body: 'Your operation with Dr. $doctorName is scheduled in 24 hours.',
        scheduledDate: twentyFourHoursBefore,
        payload: operationId,
      );
    }

    // 2 hours before
    final twoHoursBefore = appointmentDate.subtract(const Duration(hours: 2));
    if (twoHoursBefore.isAfter(DateTime.now())) {
      await scheduleReminder(
        id: operationId.hashCode + 1, // Different ID for the 2h reminder
        title: 'Surgery Today',
        body: 'Your operation with Dr. $doctorName is scheduled in 2 hours. Please prepare.',
        scheduledDate: twoHoursBefore,
        payload: operationId,
      );
    }
  }

  /// Cancel a specific reminder
  static Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
