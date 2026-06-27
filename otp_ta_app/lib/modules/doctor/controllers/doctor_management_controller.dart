import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/doctor_repository.dart';

class DoctorManagementController extends GetxController {
  final IDoctorRepository _doctorRepository;

  DoctorManagementController({required IDoctorRepository doctorRepository})
      : _doctorRepository = doctorRepository;

  final RxBool isLoading = false.obs;
  final RxList<DoctorModel> doctorList = <DoctorModel>[].obs;
  final RxList<DoctorModel> filteredDoctorList = <DoctorModel>[].obs;
  
  final Rx<DoctorModel?> currentDoctor = Rx<DoctorModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _watchDoctors();
  }

  void _watchDoctors() {
    _doctorRepository.watchAllDoctors().listen(
      (doctors) {
        doctorList.value = doctors;
        filteredDoctorList.value = doctors;
      },
      onError: (e) {
        SnackbarHelper.showError('Failed to load doctor list');
      },
    );
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctorList.value = doctorList;
      return;
    }
    
    final lowerQuery = query.toLowerCase();
    filteredDoctorList.value = doctorList.where((doctor) {
      return doctor.name.toLowerCase().contains(lowerQuery) ||
             doctor.specializations.any((spec) => spec.toLowerCase().contains(lowerQuery)) ||
             doctor.pmdc.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> fetchDoctorProfile(String uid) async {
    isLoading.value = true;
    final result = await _doctorRepository.fetchDoctor(uid);
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (doctor) => currentDoctor.value = doctor,
    );
    isLoading.value = false;
  }

  Future<void> createDoctor(DoctorModel doctor, String initialPassword) async {
    isLoading.value = true;
    try {
      // Mocking Firebase Auth User creation
      final mockUid = 'doc_${DateTime.now().millisecondsSinceEpoch}';
      final newDoctor = doctor.copyWith(doctorId: mockUid);
      
      final result = await _doctorRepository.createDoctor(newDoctor);
      
      result.fold(
        (failure) => SnackbarHelper.showError(failure.message),
        (_) {
          SnackbarHelper.showSuccess('Doctor Profile Created Successfully');
          Get.back();
        },
      );
    } catch (e) {
      SnackbarHelper.showError('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDoctor(DoctorModel doctor) async {
    isLoading.value = true;
    final result = await _doctorRepository.updateDoctor(doctor);
    
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (_) {
        SnackbarHelper.showSuccess('Doctor Profile Updated');
        if (currentDoctor.value?.doctorId == doctor.doctorId) {
          currentDoctor.value = doctor;
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> updateAccountStatus(String uid, String status) async {
    isLoading.value = true;
    final result = await _doctorRepository.updateAccountStatus(uid, status);
    
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (_) => SnackbarHelper.showSuccess('Doctor Account Status Updated to $status'),
    );
    isLoading.value = false;
  }

  // Logic for managing availability slots
  void addAvailabilitySlot(String doctorId, String slot) {
    final doctor = currentDoctor.value;
    if (doctor != null && doctor.doctorId == doctorId) {
      if (doctor.availabilitySlots.contains(slot)) {
        SnackbarHelper.showError('Slot already exists');
        return;
      }
      
      final updatedSlots = List<String>.from(doctor.availabilitySlots)..add(slot);
      final updatedDoctor = doctor.copyWith(availabilitySlots: updatedSlots);
      
      // Optimitistic update
      currentDoctor.value = updatedDoctor;
      updateDoctor(updatedDoctor);
    }
  }

  void removeAvailabilitySlot(String doctorId, String slot) {
    final doctor = currentDoctor.value;
    if (doctor != null && doctor.doctorId == doctorId) {
      final updatedSlots = List<String>.from(doctor.availabilitySlots)..remove(slot);
      final updatedDoctor = doctor.copyWith(availabilitySlots: updatedSlots);
      
      // Optimitistic update
      currentDoctor.value = updatedDoctor;
      updateDoctor(updatedDoctor);
    }
  }
}
