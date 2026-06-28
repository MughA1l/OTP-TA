import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/analytics_model.dart';
import '../../../data/repositories/report_repository.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Default timeframe setup
    _updateTimeframeDates();
    fetchAnalytics();
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
}
