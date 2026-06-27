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
        SnackbarHelper.showError('Error', 'Failed to load doctor list');
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
      (failure) => SnackbarHelper.showError('Error', failure.message),
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
        (failure) => SnackbarHelper.showError('Error', failure.message),
        (_) {
          SnackbarHelper.showSuccess('Success', 'Doctor Profile Created Successfully');
          Get.back();
        },
      );
    } catch (e) {
      SnackbarHelper.showError('Error', 'An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDoctor(DoctorModel doctor) async {
    isLoading.value = true;
    final result = await _doctorRepository.updateDoctor(doctor);
    
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Doctor Profile Updated');
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
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) => SnackbarHelper.showSuccess('Success', 'Doctor Account Status Updated to $status'),
    );
    isLoading.value = false;
  }

  // Logic for managing availability slots
  void addAvailabilitySlot(String doctorId, String slot) {
    final doctor = currentDoctor.value;
    if (doctor != null && doctor.doctorId == doctorId) {
      if (doctor.availabilitySlots.contains(slot)) {
        SnackbarHelper.showError('Error', 'Slot already exists');
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

  // ── Availability (SRS-41) ────────────────────────────────────────────────

  /// Saves a clean list of slots after conflict detection
  Future<void> saveAvailabilitySlots(String doctorId, List<String> newSlots) async {
    // Conflict detection: duplicates within the list
    final uniqueSlots = newSlots.toSet().toList();
    if (uniqueSlots.length != newSlots.length) {
      SnackbarHelper.showError('Error', 'Conflict Detected: Duplicate time slot found. (SRS-41)');
      return;
    }

    isLoading.value = true;
    final result = await _doctorRepository.updateAvailability(doctorId, uniqueSlots);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Availability Updated Successfully');
        // Refresh local doctor
        if (currentDoctor.value?.doctorId == doctorId) {
          currentDoctor.value = currentDoctor.value!.copyWith(availabilitySlots: uniqueSlots);
        }
      },
    );
    isLoading.value = false;
  }

  // ── Leave Dates ──────────────────────────────────────────────────────────

  final RxList<String> leaveDates = <String>[].obs;

  Future<void> fetchLeaveDates(String doctorId) async {
    isLoading.value = true;
    final result = await _doctorRepository.fetchLeaveDates(doctorId);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (dates) => leaveDates.value = dates,
    );
    isLoading.value = false;
  }

  Future<void> markOnLeave(String doctorId, String isoDate) async {
    if (leaveDates.contains(isoDate)) {
      SnackbarHelper.showError('Error', 'Already marked as on leave for this date.');
      return;
    }
    final updated = List<String>.from(leaveDates)..add(isoDate);
    isLoading.value = true;
    final result = await _doctorRepository.updateLeaveDates(doctorId, updated);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        leaveDates.value = updated;
        SnackbarHelper.showSuccess('Success', 'Leave marked for $isoDate');
      },
    );
    isLoading.value = false;
  }

  Future<void> removeLeaveDate(String doctorId, String isoDate) async {
    final updated = List<String>.from(leaveDates)..remove(isoDate);
    isLoading.value = true;
    final result = await _doctorRepository.updateLeaveDates(doctorId, updated);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) => leaveDates.value = updated,
    );
    isLoading.value = false;
  }
}
