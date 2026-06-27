import 'package:get/get.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/patient_repository_impl.dart';
import '../controllers/patient_management_controller.dart';

class PatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPatientRepository>(() => PatientRepositoryImpl());
    Get.lazyPut<PatientManagementController>(
      () => PatientManagementController(patientRepository: Get.find<IPatientRepository>()),
    );
  }
}
