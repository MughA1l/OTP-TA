import 'package:get/get.dart';
import '../../../data/repositories/operation_repository.dart';
import '../../../data/repositories/operation_repository_impl.dart';
import '../controllers/operation_controller.dart';

class OperationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IOperationRepository>(() => OperationRepositoryImpl());
    Get.lazyPut<OperationController>(
      () => OperationController(operationRepository: Get.find<IOperationRepository>()),
    );
  }
}
