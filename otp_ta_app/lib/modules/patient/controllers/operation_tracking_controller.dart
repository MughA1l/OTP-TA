import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/operation_model.dart';
import '../../../data/repositories/operation_repository.dart';

class OperationTrackingController extends GetxController {
  final IOperationRepository _operationRepository;

  OperationTrackingController({
    required IOperationRepository operationRepository,
  }) : _operationRepository = operationRepository;

  final Rx<OperationModel?> currentOperation = Rx<OperationModel?>(null);
  final RxBool isLoading = true.obs;

  // SRS-59: Download report state
  final RxBool isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final operationId = Get.arguments as String?;
    if (operationId != null) {
      _watchOperation(operationId);
    } else {
      isLoading.value = false;
    }
  }

  void _watchOperation(String operationId) {
    _operationRepository
        .watchOperation(operationId)
        .listen(
          (op) {
            currentOperation.value = op;
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
          },
        );
  }

  int get currentStepIndex {
    final status = currentOperation.value?.status ?? OperationStatus.scheduled;
    switch (status) {
      case OperationStatus.scheduled:
      case OperationStatus.preOp:
        return 0;
      case OperationStatus.inSurgery:
        return 1;
      case OperationStatus.recovery:
        return 2;
      case OperationStatus.completed:
        return 3;
      case OperationStatus.cancelled:
        return -1;
    }
  }

  Future<void> downloadReport(String url) async {
    try {
      isDownloading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await Printing.layoutPdf(
          onLayout: (format) async => response.bodyBytes,
        );
        SnackbarHelper.showSuccess('Success', 'Report Downloaded Successfully');
      } else {
        SnackbarHelper.showError(
          'Error',
          'Failed to download report. Server responded with ${response.statusCode}',
        );
      }
    } catch (e) {
      SnackbarHelper.showError(
        'Error',
        'An error occurred while downloading the report',
      );
    } finally {
      isDownloading.value = false;
    }
  }
}
