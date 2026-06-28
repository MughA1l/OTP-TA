import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/prescription_model.dart';
import '../../../data/repositories/medication_repository.dart';

class PrescriptionController extends GetxController {
  final IMedicationRepository _medicationRepository;

  PrescriptionController({required IMedicationRepository medicationRepository})
    : _medicationRepository = medicationRepository;

  final RxBool isLoading = false.obs;
  final Rx<PrescriptionModel?> selectedPrescription = Rx<PrescriptionModel?>(
    null,
  );
  final RxList<PrescriptionModel> prescriptionList = <PrescriptionModel>[].obs;

  /// Creates a new prescription record (SRS-82, SRS-83)
  Future<void> createPrescription(PrescriptionModel prescription) async {
    isLoading.value = true;
    final result = await _medicationRepository.addPrescription(prescription);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (docId) {
        SnackbarHelper.showSuccess(
          'Success',
          'Prescription Added Successfully',
        );
        Get.back(); // Navigate back to detail view
      },
    );
    isLoading.value = false;
  }

  /// Updates dosage details and appends audit logs (SRS-85)
  Future<void> updatePrescriptionDosage({
    required String prescriptionId,
    required List<MedicineModel> medicines,
    required String oldDosage,
    required String newDosage,
  }) async {
    isLoading.value = true;
    final currentUserId =
        Get.find<AuthController>().currentUser.value?.uid ?? 'Doctor';

    final auditLog = PrescriptionAuditLogModel(
      timestamp: DateTime.now(),
      oldDosage: oldDosage,
      newDosage: newDosage,
      changedBy: currentUserId,
    );

    final result = await _medicationRepository.updatePrescription(
      prescriptionId,
      medicines,
      auditLog,
    );
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess(
          'Success',
          'Prescription Dosage Updated Successfully',
        );
        Get.back();
      },
    );
    isLoading.value = false;
  }

  /// Fetches the prescription matching an operation
  Future<void> fetchPrescriptionForOperation(String operationId) async {
    isLoading.value = true;
    final result = await _medicationRepository.fetchPrescriptionByOperation(
      operationId,
    );
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (presc) {
        selectedPrescription.value = presc;
      },
    );
    isLoading.value = false;
  }

  /// Fetches patient schedule history list
  Future<void> fetchMedicationSchedule(String patientId) async {
    isLoading.value = true;
    final result = await _medicationRepository.fetchSchedule(patientId);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (list) {
        prescriptionList.value = list;
      },
    );
    isLoading.value = false;
  }

  /// Watches patient medication schedule in real-time
  Stream<List<PrescriptionModel>> watchPatientMedications(String patientId) {
    return _medicationRepository.watchPatientPrescriptions(patientId);
  }
}
