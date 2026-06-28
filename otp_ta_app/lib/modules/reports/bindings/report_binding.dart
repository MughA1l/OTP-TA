import 'package:get/get.dart';
import '../../../data/repositories/report_repository.dart';
import '../../../data/repositories/report_repository_impl.dart';
import '../controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IReportRepository>(() => ReportRepositoryImpl(), fenix: true);
    Get.lazyPut<ReportController>(
      () => ReportController(reportRepository: Get.find<IReportRepository>()),
      fenix: true,
    );
  }
}
