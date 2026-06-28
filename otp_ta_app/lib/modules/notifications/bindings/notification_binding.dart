import 'package:get/get.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/notification_repository_impl.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INotificationRepository>(() => NotificationRepositoryImpl(), fenix: true);
    Get.lazyPut<NotificationController>(
      () => NotificationController(notificationRepository: Get.find<INotificationRepository>()),
      fenix: true,
    );
  }
}
