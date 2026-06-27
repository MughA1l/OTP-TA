import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find<IAuthRepository>()),
    );
  }
}
