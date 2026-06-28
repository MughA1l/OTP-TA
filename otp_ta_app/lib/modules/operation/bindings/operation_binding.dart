import 'package:get/get.dart';
import '../../../data/repositories/operation_repository.dart';
import '../../../data/repositories/operation_repository_impl.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../../data/repositories/patient_repository_impl.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../../../data/repositories/staff_repository.dart';
import '../../../data/repositories/staff_repository_impl.dart';
import '../controllers/operation_controller.dart';

class OperationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPatientRepository>(() => PatientRepositoryImpl());
    Get.lazyPut<IDoctorRepository>(() => DoctorRepositoryImpl());
    Get.lazyPut<IStaffRepository>(() => StaffRepositoryImpl());
    Get.lazyPut<IOperationRepository>(() => OperationRepositoryImpl());
    Get.lazyPut<OperationController>(
      () => OperationController(
        operationRepository: Get.find<IOperationRepository>(),
        patientRepository: Get.find<IPatientRepository>(),
        doctorRepository: Get.find<IDoctorRepository>(),
        staffRepository: Get.find<IStaffRepository>(),
      ),
    );
  }
}
