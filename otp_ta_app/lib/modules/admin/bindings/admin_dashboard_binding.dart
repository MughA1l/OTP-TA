import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/appointment_repository_impl.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    Get.lazyPut<IAppointmentRepository>(() => AppointmentRepositoryImpl());
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(
        doctorRepository: Get.find<IDoctorRepository>(),
        appointmentRepository: Get.find<IAppointmentRepository>(),
      ),
    );
  }
}
