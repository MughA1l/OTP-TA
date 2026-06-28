import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/notification_model.dart';

abstract class INotificationRepository {
  /// Watch notifications for a specific user.
  Stream<List<NotificationModel>> watchNotifications(String userId);

  /// Mark a specific notification as read.
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Clear all notifications for a specific user.
  Future<Either<Failure, void>> clearAll(String userId);
}
