import 'package:get/get.dart';
import '../../../data/repositories/role_permission_repository.dart';
import '../../../data/repositories/role_permission_repository_impl.dart';
import '../controllers/role_permission_controller.dart';

class RolePermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRolePermissionRepository>(() => RolePermissionRepositoryImpl());
    Get.lazyPut<RolePermissionController>(
      () => RolePermissionController(repository: Get.find<IRolePermissionRepository>()),
    );
  }
}
