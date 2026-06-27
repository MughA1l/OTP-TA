import 'package:get/get.dart';
import '../../../data/repositories/operation_repository.dart';
import '../../../data/repositories/operation_repository_impl.dart';
import '../controllers/operation_tracking_controller.dart';

class OperationTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IOperationRepository>(() => OperationRepositoryImpl());
    Get.lazyPut<OperationTrackingController>(
      () => OperationTrackingController(
        operationRepository: Get.find<IOperationRepository>(),
      ),
    );
  }
}
