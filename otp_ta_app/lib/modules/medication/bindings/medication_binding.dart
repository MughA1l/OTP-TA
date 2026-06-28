import 'package:get/get.dart';
import '../../../data/repositories/medication_repository.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../controllers/prescription_controller.dart';

class MedicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IMedicationRepository>(() => MedicationRepositoryImpl());
    Get.lazyPut<PrescriptionController>(
      () => PrescriptionController(medicationRepository: Get.find<IMedicationRepository>()),
    );
  }
}
