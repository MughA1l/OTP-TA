import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/repositories/patient_repository.dart';

class PatientManagementController extends GetxController {
  final IPatientRepository _patientRepository;

  PatientManagementController({required IPatientRepository patientRepository})
      : _patientRepository = patientRepository;

  final RxBool isLoading = false.obs;
  final RxList<PatientModel> patientList = <PatientModel>[].obs;
  final RxList<PatientModel> filteredPatientList = <PatientModel>[].obs;
  
  // For the mobile view
  final Rx<PatientModel?> currentPatient = Rx<PatientModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _watchPatients();
  }

  void _watchPatients() {
    _patientRepository.watchAllPatients().listen(
      (patients) {
        patientList.value = patients;
        filteredPatientList.value = patients;
      },
      onError: (e) {
        SnackbarHelper.showError('Failed to load patient list');
      },
    );
  }

  void filterPatients(String query) {
    if (query.isEmpty) {
      filteredPatientList.value = patientList;
      return;
    }
    
    final lowerQuery = query.toLowerCase();
    filteredPatientList.value = patientList.where((patient) {
      return patient.name.toLowerCase().contains(lowerQuery) ||
             patient.patientId.toLowerCase().contains(lowerQuery) ||
             patient.phone.contains(lowerQuery);
    }).toList();
  }

  Future<void> createPatient(PatientModel patient, String initialPassword) async {
    isLoading.value = true;
    try {
      // Mocking Firebase Auth User creation
      final mockUid = 'pat_${DateTime.now().millisecondsSinceEpoch}';
      final newPatient = patient.copyWith(uid: mockUid);
      
      final result = await _patientRepository.createPatient(newPatient);
      
      result.fold(
        (failure) => SnackbarHelper.showError(failure.message),
        (_) {
          SnackbarHelper.showSuccess('Patient Profile Created Successfully'); // SRS-27
          Get.back();
        },
      );
    } catch (e) {
      SnackbarHelper.showError('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePatient(PatientModel patient) async {
    isLoading.value = true;
    final result = await _patientRepository.updatePatient(patient);
    
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (_) {
        SnackbarHelper.showSuccess('Patient Profile Updated');
        if (currentPatient.value?.uid == patient.uid) {
          currentPatient.value = patient;
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchPatientProfile(String uid) async {
    isLoading.value = true;
    final result = await _patientRepository.fetchPatient(uid);
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (patient) => currentPatient.value = patient,
    );
    isLoading.value = false;
  }
}
