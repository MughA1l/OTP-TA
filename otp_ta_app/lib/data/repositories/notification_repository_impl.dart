import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to mark notification as read.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right(null);
      }

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to clear notifications.',
        ),
      );
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }
}
