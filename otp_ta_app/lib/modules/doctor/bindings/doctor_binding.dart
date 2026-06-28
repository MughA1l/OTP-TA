import 'package:get/get.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../controllers/doctor_management_controller.dart';

class DoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    Get.lazyPut<DoctorManagementController>(
      () => DoctorManagementController(
        doctorRepository: Get.find<IDoctorRepository>(),
      ),
    );
  }
}
