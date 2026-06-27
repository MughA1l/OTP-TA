import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/doctor_repository.dart';

class AppointmentController extends GetxController {
  final IAppointmentRepository _appointmentRepository;
  final IDoctorRepository _doctorRepository;

  AppointmentController({
    required IAppointmentRepository appointmentRepository,
    required IDoctorRepository doctorRepository,
  })  : _appointmentRepository = appointmentRepository,
        _doctorRepository = doctorRepository;

  final RxBool isLoading = false.obs;
  final RxList<AppointmentModel> allAppointments = <AppointmentModel>[].obs;
  final RxList<DoctorModel> doctorList = <DoctorModel>[].obs;

  // Booking form state
  final Rx<DoctorModel?> selectedDoctor = Rx<DoctorModel?>(null);
  final Rx<String?> selectedSlot = Rx<String?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedPatientId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _watchAppointments();
    _watchDoctors();
  }

  void _watchAppointments() {
    _appointmentRepository.watchAllAppointments().listen(
      (list) => allAppointments.value = list,
      onError: (_) => SnackbarHelper.showError('Error', 'Failed to load appointments'),
    );
  }

  void _watchDoctors() {
    _doctorRepository.watchAllDoctors().listen(
      (list) => doctorList.value = list,
    );
  }

  void selectDoctor(DoctorModel? doctor) {
    selectedDoctor.value = doctor;
    selectedSlot.value = null; // reset slot on doctor change
  }

  /// Returns slots that are not already booked on the selected date
  List<String> get availableSlots {
    final doctor = selectedDoctor.value;
    final date = selectedDate.value;
    if (doctor == null || date == null) return [];

    // Filter to day-of-week slots
    final dayName = _dayName(date.weekday);
    final daySlots = doctor.availabilitySlots
        .where((s) => s.startsWith(dayName))
        .toList();

    // Remove slots already booked at the same date+slot
    final bookedSlots = allAppointments
        .where((a) =>
            a.doctorId == doctor.doctorId &&
            a.status != AppointmentStatus.cancelled &&
            _isSameDate(a.dateTime, date))
        .map((a) => a.notes ?? '') // notes field used as slot label
        .toSet();

    return daySlots.where((s) => !bookedSlots.contains(s)).toList();
  }

  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Evaluates if a given time slot is available on a specific date for a doctor
  bool isSlotAvailable(DoctorModel doctor, DateTime date, String slot) {
    // 1. Check if the day of week matches doctor's availability
    // Format weekday short name, e.g. "Mon"
    final dayName = _dayName(date.weekday);
    
    // Format check string, e.g., "Mon|Morning (8am–12pm)"
    final checkString = '$dayName|$slot';
    
    if (!doctor.availabilitySlots.contains(checkString)) {
      return false;
    }

    // 2. Check for appointment conflicts (overlap) in Firestore (SRS-42)
    final hasConflict = allAppointments.any((appt) {
      if (appt.doctorId != doctor.doctorId) return false;
      if (appt.status == AppointmentStatus.cancelled) return false;
      
      final isSameDate = appt.dateTime.year == date.year &&
                         appt.dateTime.month == date.month &&
                         appt.dateTime.day == date.day;
      
      // Slot name is stored in notes field
      final isSameSlot = appt.notes == slot;

      return isSameDate && isSameSlot;
    });

    return !hasConflict;
  }

  Future<void> bookAppointment(String patientId) async {
    final doctor = selectedDoctor.value;
    final date = selectedDate.value;
    final slot = selectedSlot.value;

    if (doctor == null || date == null || slot == null || patientId.isEmpty) {
      SnackbarHelper.showError('Error', 'Please fill all fields before booking.');
      return;
    }

    isLoading.value = true;
    final appointment = AppointmentModel(
      appointmentId: '',
      doctorId: doctor.doctorId,
      patientId: patientId,
      dateTime: date,
      createdAt: DateTime.now(),
      notes: slot, // store slot label in notes
    );

    final result = await _appointmentRepository.bookAppointment(appointment);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        SnackbarHelper.showSuccess('Success', 'Appointment Booked Successfully');
        _resetForm();
        Get.back();
      },
    );
    isLoading.value = false;
  }

  void _resetForm() {
    selectedDoctor.value = null;
    selectedSlot.value = null;
    selectedDate.value = null;
    selectedPatientId.value = '';
  }

  Future<void> reschedule(String appointmentId, DateTime newDateTime) async {
    isLoading.value = true;
    final result = await _appointmentRepository.reschedule(appointmentId, newDateTime);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) => SnackbarHelper.showSuccess('Success', 'Appointment Rescheduled'),
    );
    isLoading.value = false;
  }

  Future<void> cancel(String appointmentId) async {
    isLoading.value = true;
    final result = await _appointmentRepository.cancel(appointmentId);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) => SnackbarHelper.showSuccess('Success', 'Appointment Cancelled'), // SRS-44
    );
    isLoading.value = false;
  }

  Future<void> updateStatus(String appointmentId, AppointmentStatus status) async {
    isLoading.value = true;
    final result = await _appointmentRepository.updateStatus(appointmentId, status);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) => SnackbarHelper.showSuccess('Success', 'Status updated to ${status.name}'),
    );
    isLoading.value = false;
  }
}
