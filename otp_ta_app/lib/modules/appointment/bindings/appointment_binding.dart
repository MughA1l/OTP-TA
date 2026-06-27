import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/appointment_repository_impl.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../controllers/appointment_controller.dart';

class AppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAppointmentRepository>(() => AppointmentRepositoryImpl());
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    Get.lazyPut<AppointmentController>(
      () => AppointmentController(
        appointmentRepository: Get.find<IAppointmentRepository>(),
        doctorRepository: Get.find<IDoctorRepository>(),
      ),
    );
  }
}
