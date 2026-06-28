import 'package:get/get.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/chat_repository_impl.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IChatRepository>(() => ChatRepositoryImpl());
    Get.lazyPut<ChatController>(
      () => ChatController(chatRepository: Get.find<IChatRepository>()),
    );
  }
}
