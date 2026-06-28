import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/analytics_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/operation_model.dart';
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

  // Live Operations for reactive stats
  final RxList<OperationModel> liveOperations = <OperationModel>[].obs;
  final RxString selectedDemographic = 'all'.obs;

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

    // Stream live operations for auto-updating charts (SRS-112)
    FirebaseFirestore.instance.collection('operations').snapshots().listen((snapshot) {
      liveOperations.value = snapshot.docs
          .map((doc) => OperationModel.fromMap(doc.data(), doc.id))
          .toList();
      _computeLiveRecoveryAnalytics();
    });
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

  void changeDemographic(String demographic) {
    selectedDemographic.value = demographic;
    _computeLiveRecoveryAnalytics();
  }

  void _computeLiveRecoveryAnalytics() {
    int under2h = 0;
    int between2and4h = 0;
    int between4and8h = 0;
    int over8h = 0;
    int readmissions = 0;

    // Filter live operations
    var filtered = liveOperations.where((op) {
      // 1. Timeframe/Date filter
      if (startDate.value != null && op.scheduledDate.isBefore(startDate.value!.subtract(const Duration(days: 1)))) {
        return false;
      }
      if (endDate.value != null && op.scheduledDate.isAfter(endDate.value!.add(const Duration(days: 1)))) {
        return false;
      }
      // 2. Surgery type filter
      if (selectedSurgeryType.value.isNotEmpty && op.surgeryType != selectedSurgeryType.value) {
        return false;
      }
      // 3. Demographic filter (mock based on patientId hashing)
      final ageGroup = op.patientId.hashCode % 3; // 0 = pediatric, 1 = adult, 2 = geriatric
      if (selectedDemographic.value == 'pediatric' && ageGroup != 0) return false;
      if (selectedDemographic.value == 'adult' && ageGroup != 1) return false;
      if (selectedDemographic.value == 'geriatric' && ageGroup != 2) return false;
      
      return true;
    }).toList();

    for (var op in filtered) {
      final outcome = op.outcome;
      if (outcome != null) {
        final notes = outcome.notes.toLowerCase();
        final complications = outcome.complications.toLowerCase();
        
        if (complications.contains('readmit') || notes.contains('readmission')) {
          readmissions++;
        }

        // Mock/parse recovery time
        double recTime = 3.0;
        if (notes.contains('recovery:')) {
          final idx = notes.indexOf('recovery:');
          final substr = notes.substring(idx + 9).trim();
          final match = RegExp(r'^\d+').firstMatch(substr);
          if (match != null) {
            recTime = double.tryParse(match.group(0)!) ?? 3.0;
          }
        } else {
          recTime = (op.operationId.hashCode % 10) + 1.0;
        }

        if (recTime < 2) {
          under2h++;
        } else if (recTime <= 4) {
          between2and4h++;
        } else if (recTime <= 8) {
          between4and8h++;
        } else {
          over8h++;
        }
      }
    }

    final totalWithOutcome = under2h + between2and4h + between4and8h + over8h;
    final readmissionRate = filtered.isNotEmpty ? (readmissions / filtered.length) * 100 : 0.0;

    recoveryStats.value = {
      'distribution': {
        '< 2h': under2h,
        '2-4h': between2and4h,
        '4-8h': between4and8h,
        '> 8h': over8h,
      },
      'readmissions': readmissions,
      'readmissionRate': readmissionRate,
      'totalWithOutcome': totalWithOutcome,
    };
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
