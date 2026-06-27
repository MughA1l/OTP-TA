import 'package:get/get.dart';
import '../../../data/repositories/staff_repository.dart';
import '../../../data/repositories/staff_repository_impl.dart';
import '../controllers/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IStaffRepository>(() => StaffRepositoryImpl());
    Get.lazyPut<StaffController>(
      () => StaffController(staffRepository: Get.find<IStaffRepository>()),
    );
  }
}
