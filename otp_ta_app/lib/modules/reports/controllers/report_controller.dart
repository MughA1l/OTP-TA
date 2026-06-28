import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/analytics_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/report_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class ReportController extends GetxController {
  final IReportRepository _reportRepository;

  ReportController({required IReportRepository reportRepository}) : _reportRepository = reportRepository;

  final RxBool isLoading = false.obs;
  
  // Filtering States
  final RxString selectedTimeframe = 'weekly'.obs; // 'weekly', 'monthly', 'custom'
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final RxString selectedOtRoom = ''.obs;
  final RxString selectedSurgeryType = ''.obs;

  // Resolved Analytical Data
  final Rxn<AnalyticsCacheModel> analytics = Rxn<AnalyticsCacheModel>();
  final RxMap<String, dynamic> recoveryStats = <String, dynamic>{}.obs;

  // Doctor performance specific state
  final Rxn<DoctorPerformanceModel> doctorPerformance = Rxn<DoctorPerformanceModel>();
  final RxList<UserModel> doctorsList = <UserModel>[].obs;
  final RxString selectedDoctorId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Default timeframe setup
    _updateTimeframeDates();
    fetchAnalytics();
    
    final user = Get.find<AuthController>().currentUser.value;
    if (user != null) {
      if (user.role == UserRole.doctor) {
        selectedDoctorId.value = user.uid;
        fetchDoctorPerformanceData(user.uid);
      } else if (user.role == UserRole.admin) {
        fetchDoctors();
      }
    }
  }

  void changeTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
    _updateTimeframeDates();
    fetchAnalytics();
  }

  void setCustomDates(DateTime start, DateTime end) {
    selectedTimeframe.value = 'custom';
    startDate.value = start;
    endDate.value = end;
    fetchAnalytics();
  }

  void filterByRoom(String otRoom) {
    selectedOtRoom.value = otRoom;
    fetchAnalytics();
  }

  void filterByType(String type) {
    selectedSurgeryType.value = type;
    fetchAnalytics();
  }

  void _updateTimeframeDates() {
    final now = DateTime.now();
    if (selectedTimeframe.value == 'weekly') {
      startDate.value = now.subtract(const Duration(days: 7));
      endDate.value = now;
    } else if (selectedTimeframe.value == 'monthly') {
      startDate.value = now.subtract(const Duration(days: 30));
      endDate.value = now;
    }
  }

  Future<void> fetchAnalytics() async {
    isLoading.value = true;
    
    final filters = <String, dynamic>{
      'startDate': startDate.value,
      'endDate': endDate.value,
      if (selectedOtRoom.value.isNotEmpty) 'otRoom': selectedOtRoom.value,
      if (selectedSurgeryType.value.isNotEmpty) 'surgeryType': selectedSurgeryType.value,
    };

    final result = await _reportRepository.fetchOperationAnalytics(filters);
    
    result.fold(
      (failure) => SnackbarHelper.showError('Analytics Error', failure.message),
      (data) {
        analytics.value = data;
      },
    );

    // Fetch recovery analytics
    final recResult = await _reportRepository.fetchRecoveryAnalytics(filters);
    recResult.fold(
      (failure) {},
      (data) {
        recoveryStats.value = data;
      },
    );

    isLoading.value = false;
  }

  Future<void> fetchDoctorPerformanceData(String doctorId) async {
    isLoading.value = true;
    final result = await _reportRepository.fetchDoctorPerformance(doctorId);
    result.fold(
      (failure) => SnackbarHelper.showError('Doctor Stats Error', failure.message),
      (data) {
        doctorPerformance.value = data;
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchDoctors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();
      doctorsList.value = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (_) {}
  }
}
