import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/appointment_repository_impl.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/patient_repository_impl.dart';
import '../../auth/controllers/auth_controller.dart';
import 'patient_dashboard_controller.dart';

class PatientDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPatientRepository>(() => PatientRepositoryImpl());
    Get.lazyPut<IAppointmentRepository>(() => AppointmentRepositoryImpl());
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    
    Get.lazyPut<PatientDashboardController>(
      () => PatientDashboardController(
        authController: Get.find<AuthController>(),
        patientRepository: Get.find<IPatientRepository>(),
        appointmentRepository: Get.find<IAppointmentRepository>(),
        doctorRepository: Get.find<IDoctorRepository>(),
      ),
    );
  }
}
