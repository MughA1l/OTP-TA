import 'dart:async';

import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/doctor_repository.dart';

class AdminDashboardController extends GetxController {
  final IDoctorRepository _doctorRepository;
  final IAppointmentRepository _appointmentRepository;

  AdminDashboardController({
    required IDoctorRepository doctorRepository,
    required IAppointmentRepository appointmentRepository,
  }) : _doctorRepository = doctorRepository,
       _appointmentRepository = appointmentRepository;

  final RxList<DoctorModel> doctors = <DoctorModel>[].obs;
  final RxList<AppointmentModel> allAppointments = <AppointmentModel>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<List<DoctorModel>>? _doctorsSubscription;
  StreamSubscription<List<AppointmentModel>>? _appointmentsSubscription;
  bool _doctorsLoaded = false;
  bool _appointmentsLoaded = false;

  @override
  void onInit() {
    super.onInit();
    _watchData();
  }

  void _watchData() {
    _doctorsSubscription = _doctorRepository.watchAllDoctors().listen(
      (docs) {
        doctors.value = docs;
        _doctorsLoaded = true;
        _checkLoading();
      },
      onError: (_) {
        _doctorsLoaded = true;
        SnackbarHelper.showError('Error', 'Failed to load doctors');
        _checkLoading();
      },
    );

    _appointmentsSubscription = _appointmentRepository
        .watchAllAppointments()
        .listen(
          (appts) {
            allAppointments.value = appts;
            _appointmentsLoaded = true;
            _checkLoading();
          },
          onError: (_) {
            _appointmentsLoaded = true;
            SnackbarHelper.showError('Error', 'Failed to load appointments');
            _checkLoading();
          },
        );
  }

  void _checkLoading() {
    if (_doctorsLoaded && _appointmentsLoaded) {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _doctorsSubscription?.cancel();
    _appointmentsSubscription?.cancel();
    super.onClose();
  }

  /// Returns total appointments scheduled today across the clinic
  int get totalAppointmentsToday {
    final now = DateTime.now();
    return allAppointments
        .where(
          (a) =>
              a.status != AppointmentStatus.cancelled &&
              _isSameDate(a.dateTime, now),
        )
        .length;
  }

  /// Returns total active doctors
  int get totalDoctors => doctors.length;

  /// Returns workload for a specific doctor today (SRS-49)
  int getDoctorWorkloadToday(String doctorId) {
    final now = DateTime.now();
    return allAppointments
        .where(
          (a) =>
              a.doctorId == doctorId &&
              a.status != AppointmentStatus.cancelled &&
              _isSameDate(a.dateTime, now),
        )
        .length;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
