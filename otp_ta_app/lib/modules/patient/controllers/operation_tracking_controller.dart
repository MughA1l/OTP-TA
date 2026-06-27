import 'package:get/get.dart';
import '../../../data/models/operation_model.dart';
import '../../../data/repositories/operation_repository.dart';

class OperationTrackingController extends GetxController {
  final IOperationRepository _operationRepository;

  OperationTrackingController({
    required IOperationRepository operationRepository,
  }) : _operationRepository = operationRepository;

  final Rx<OperationModel?> currentOperation = Rx<OperationModel?>(null);
  final RxBool isLoading = true.obs;

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
    _operationRepository.watchOperation(operationId).listen(
      (op) {
        currentOperation.value = op;
        isLoading.value = false;
      },
      onError: (_) {
        isLoading.value = false;
      },
    );
  }

  // Helper method for UI to determine active step index
  int get currentStepIndex {
    final status = currentOperation.value?.status ?? OperationStatus.preOp;
    switch (status) {
      case OperationStatus.preOp:
        return 0;
      case OperationStatus.inSurgery:
        return 1;
      case OperationStatus.recovery:
        return 2;
      case OperationStatus.completed:
        return 3;
    }
  }
}
