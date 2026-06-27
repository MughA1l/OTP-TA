import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class AssignedPatientsController extends GetxController {
  final IAppointmentRepository _appointmentRepository;
  final IPatientRepository _patientRepository;
  final AuthController _authController;

  AssignedPatientsController({
    required IAppointmentRepository appointmentRepository,
    required IPatientRepository patientRepository,
    required AuthController authController,
  })  : _appointmentRepository = appointmentRepository,
        _patientRepository = patientRepository,
        _authController = authController;

  final RxBool isLoading = false.obs;
  
  // All appointments for the logged-in doctor
  final RxList<AppointmentModel> myAppointments = <AppointmentModel>[].obs;
  
  // Filtered appointments for the UI
  final RxList<AppointmentModel> filteredAppointments = <AppointmentModel>[].obs;
  
  // Cache for patient details: patientId -> PatientModel
  final RxMap<String, PatientModel> patientCache = <String, PatientModel>{}.obs;

  // Filters
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _watchMyAppointments();
  }

  void _watchMyAppointments() {
    final uid = _authController.currentUser.value?.uid;
    if (uid == null) return;

    _appointmentRepository.watchDoctorAppointments(uid).listen(
      (appointments) {
        myAppointments.value = appointments;
        _fetchMissingPatients(appointments);
        applyFilters();
      },
      onError: (_) => SnackbarHelper.showError('Failed to load appointments'),
    );
  }

  Future<void> _fetchMissingPatients(List<AppointmentModel> appointments) async {
    for (final appt in appointments) {
      if (!patientCache.containsKey(appt.patientId)) {
        // Fetch patient details
        final result = await _patientRepository.fetchPatient(appt.patientId);
        result.fold(
          (l) => null, // Ignore error, maybe patient was deleted
          (patient) => patientCache[appt.patientId] = patient,
        );
      }
    }
    // Re-apply filters in case search query depends on patient name
    applyFilters();
  }

  void setDateFilter(DateTime date) {
    selectedDate.value = date;
    applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase();
    
    filteredAppointments.value = myAppointments.where((appt) {
      // 1. Filter by Date (SRS-47)
      final isSameDate = appt.dateTime.year == selectedDate.value.year &&
                         appt.dateTime.month == selectedDate.value.month &&
                         appt.dateTime.day == selectedDate.value.day;
      
      if (!isSameDate) return false;

      // 2. Search by Name or ID (SRS-47)
      if (query.isNotEmpty) {
        final patient = patientCache[appt.patientId];
        final matchesId = appt.patientId.toLowerCase().contains(query);
        final matchesName = patient != null && patient.name.toLowerCase().contains(query);
        if (!matchesId && !matchesName) return false;
      }

      return true;
    }).toList();
  }

  PatientModel? getPatientDetails(String patientId) {
    return patientCache[patientId];
  }

  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    isLoading.value = true;
    final result = await _appointmentRepository.updateStatus(appointmentId, status);
    result.fold(
      (failure) => SnackbarHelper.showError(failure.message),
      (_) => SnackbarHelper.showSuccess('Status updated to ${status.name}'),
    );
    isLoading.value = false;
  }
}
