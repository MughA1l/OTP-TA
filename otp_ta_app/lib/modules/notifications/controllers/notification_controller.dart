import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class NotificationController extends GetxController {
  final INotificationRepository _notificationRepository;

  NotificationController({
    required INotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // React to user auth status and bind stream
    ever(Get.find<AuthController>().currentUser, (user) {
      if (user != null && user.uid.isNotEmpty) {
        _bindNotificationsStream(user.uid);
      } else {
        notifications.clear();
        unreadCount.value = 0;
      }
    });

    final currentUserId =
        Get.find<AuthController>().currentUser.value?.uid ?? '';
    if (currentUserId.isNotEmpty) {
      _bindNotificationsStream(currentUserId);
    }
  }

  void _bindNotificationsStream(String userId) {
    notifications.bindStream(
      _notificationRepository.watchNotifications(userId).map((list) {
        unreadCount.value = list.where((n) => !n.isRead).length;
        return list;
      }),
    );
  }

  /// Marks a specific notification as read (SRS-103)
  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }

  /// Clears all notifications for the current user (SRS-103)
  Future<void> clearAll() async {
    final currentUserId =
        Get.find<AuthController>().currentUser.value?.uid ?? '';
    if (currentUserId.isEmpty) return;

    isLoading.value = true;
    final result = await _notificationRepository.clearAll(currentUserId);
    isLoading.value = false;

    result.fold(
      (failure) => SnackbarHelper.showError('Failed to Clear', failure.message),
      (_) {
        // Handled silently or with a snackbar
      },
    );
  }
}
