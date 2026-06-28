import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../../data/repositories/patient_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class PatientDashboardController extends GetxController {
  final AuthController _authController;
  final IPatientRepository _patientRepository;
  final IAppointmentRepository _appointmentRepository;
  final IDoctorRepository _doctorRepository;

  PatientDashboardController({
    required AuthController authController,
    required IPatientRepository patientRepository,
    required IAppointmentRepository appointmentRepository,
    required IDoctorRepository doctorRepository,
  }) : _authController = authController,
       _patientRepository = patientRepository,
       _appointmentRepository = appointmentRepository,
       _doctorRepository = doctorRepository;

  final Rx<PatientModel?> currentPatient = Rx<PatientModel?>(null);
  final RxList<AppointmentModel> myAppointments = <AppointmentModel>[].obs;
  final RxMap<String, DoctorModel> doctorCache = <String, DoctorModel>{}.obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    final uid = _authController.currentUser.value?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    // Fetch current patient profile once
    final result = await _patientRepository.fetchPatient(uid);
    result.fold((l) => null, (patient) => currentPatient.value = patient);

    // Watch real-time appointments for this patient
    _appointmentRepository.watchPatientAppointments(uid).listen((appointments) {
      myAppointments.value = appointments;
      _fetchMissingDoctors(appointments);
      isLoading.value = false;
    });
  }

  Future<void> _fetchMissingDoctors(List<AppointmentModel> appointments) async {
    for (final appt in appointments) {
      if (!doctorCache.containsKey(appt.doctorId)) {
        final result = await _doctorRepository.fetchDoctor(appt.doctorId);
        result.fold((l) => null, (doc) => doctorCache[appt.doctorId] = doc);
      }
    }
  }

  /// Returns the upcoming scheduled appointment, if any
  AppointmentModel? get upcomingAppointment {
    final scheduled = myAppointments
        .where(
          (a) =>
              a.status == AppointmentStatus.scheduled &&
              a.dateTime.isAfter(DateTime.now()),
        )
        .toList();
    if (scheduled.isEmpty) return null;
    scheduled.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return scheduled.first;
  }

  /// Returns the doctor for the given appointment
  DoctorModel? getDoctorForAppointment(String doctorId) {
    return doctorCache[doctorId];
  }
}
