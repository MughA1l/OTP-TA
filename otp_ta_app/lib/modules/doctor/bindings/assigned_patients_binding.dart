import 'package:get/get.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/assigned_patients_controller.dart';

class AssignedPatientsBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories should ideally be registered globally or via their own bindings,
    // but Get.find will resolve them if they are registered. Assuming they are available
    // via PatientBinding and AppointmentBinding, but we can register them if not.
    Get.lazyPut<AssignedPatientsController>(
      () => AssignedPatientsController(
        appointmentRepository: Get.find<IAppointmentRepository>(),
        patientRepository: Get.find<IPatientRepository>(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
