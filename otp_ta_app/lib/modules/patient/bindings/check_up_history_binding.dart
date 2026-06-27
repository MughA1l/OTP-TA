import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/appointment_repository_impl.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/check_up_history_controller.dart';

class CheckUpHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAppointmentRepository>(() => AppointmentRepositoryImpl());
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    Get.lazyPut<CheckUpHistoryController>(
      () => CheckUpHistoryController(
        appointmentRepository: Get.find<IAppointmentRepository>(),
        doctorRepository: Get.find<IDoctorRepository>(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
