import 'package:get/get.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../data/repositories/doctor_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class CheckUpHistoryController extends GetxController {
  final IAppointmentRepository _appointmentRepository;
  final IDoctorRepository _doctorRepository;
  final AuthController _authController;

  CheckUpHistoryController({
    required IAppointmentRepository appointmentRepository,
    required IDoctorRepository doctorRepository,
    required AuthController authController,
  })  : _appointmentRepository = appointmentRepository,
        _doctorRepository = doctorRepository,
        _authController = authController;

  final RxList<AppointmentModel> _allAppointments = <AppointmentModel>[].obs;
  final RxMap<String, DoctorModel> doctorCache = <String, DoctorModel>{}.obs;

  // Observables
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = false.obs;
  final RxInt currentLimit = 10.obs;

  // Search & Filters
  final RxString searchQuery = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Final lists
  final RxList<AppointmentModel> filteredAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> paginatedAppointments = <AppointmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final uid = _authController.currentUser.value?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    // Load doctors first/parallelly to resolve names
    _doctorRepository.watchAllDoctors().listen((docs) {
      for (var doc in docs) {
        doctorCache[doc.doctorId] = doc;
      }
      _applyFiltersAndPagination();
    });

    // Listen to patient's appointments
    _appointmentRepository.watchPatientAppointments(uid).listen((appts) {
      _allAppointments.value = appts;
      _applyFiltersAndPagination();
      isLoading.value = false;
    }, onError: (_) {
      isLoading.value = false;
    });

    // React to filter changes
    ever(searchQuery, (_) => _resetAndApplyFilters());
    ever(startDate, (_) => _resetAndApplyFilters());
    ever(endDate, (_) => _resetAndApplyFilters());
    ever(currentLimit, (_) => _applyFiltersAndPagination(isPaginating: true));
  }

  void _resetAndApplyFilters() {
    currentLimit.value = 10;
    _applyFiltersAndPagination();
  }

  void _applyFiltersAndPagination({bool isPaginating = false}) {
    if (!isPaginating) {
      isLoadingMore.value = false;
    }

    // Filter past appointments (SRS-60)
    // Past appointments = status is completed/noShow, or scheduled but date has passed
    final now = DateTime.now();
    final pastAppts = _allAppointments.where((appt) {
      final isPastStatus = appt.status == AppointmentStatus.completed || 
                           appt.status == AppointmentStatus.noShow ||
                           appt.status == AppointmentStatus.cancelled;
      final isPastTime = appt.dateTime.isBefore(now);
      return isPastStatus || isPastTime;
    }).toList();

    // Sort descending (newest first)
    pastAppts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Apply Search Filters (SRS-61)
    final query = searchQuery.value.trim().toLowerCase();
    final start = startDate.value;
    final end = endDate.value;

    final filtered = pastAppts.where((appt) {
      // Doctor search
      if (query.isNotEmpty) {
        final doc = doctorCache[appt.doctorId];
        final docName = doc?.name.toLowerCase() ?? '';
        if (!docName.contains(query)) {
          return false;
        }
      }

      // Date range search
      if (start != null) {
        // Normalize to start of day
        final apptDate = DateTime(appt.dateTime.year, appt.dateTime.month, appt.dateTime.day);
        final filterStart = DateTime(start.year, start.month, start.day);
        if (apptDate.isBefore(filterStart)) {
          return false;
        }
      }

      if (end != null) {
        final apptDate = DateTime(appt.dateTime.year, appt.dateTime.month, appt.dateTime.day);
        final filterEnd = DateTime(end.year, end.month, end.day);
        if (apptDate.isAfter(filterEnd)) {
          return false;
        }
      }

      return true;
    }).toList();

    filteredAppointments.value = filtered;

    // Apply Pagination (SRS-80)
    final limit = currentLimit.value;
    if (filtered.length > limit) {
      paginatedAppointments.value = filtered.sublist(0, limit);
      hasMore.value = true;
    } else {
      paginatedAppointments.value = filtered;
      hasMore.value = false;
    }
    isLoadingMore.value = false;
  }

  void loadMore() {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    
    // Simulate network delay for premium feel / shimmer
    Future.delayed(const Duration(milliseconds: 600), () {
      currentLimit.value += 10;
    });
  }

  void clearFilters() {
    searchQuery.value = '';
    startDate.value = null;
    endDate.value = null;
  }

  DoctorModel? getDoctor(String doctorId) {
    return doctorCache[doctorId];
  }
}
