import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/role_permission_model.dart';
import '../../../data/repositories/role_permission_repository.dart';

class RolePermissionController extends GetxController {
  final IRolePermissionRepository _repository;

  RolePermissionController({required IRolePermissionRepository repository})
      : _repository = repository;

  final RxBool isLoading = false.obs;
  final RxList<RolePermissionModel> rolePermissions = <RolePermissionModel>[].obs;
  
  // Hardcoded list of all available modules in the system
  final List<String> allModules = [
    'Dashboard',
    'Staff',
    'Patients',
    'Procedures',
    'Appointments',
    'Reports',
    'Settings',
    'Profile',
  ];

  @override
  void onInit() {
    super.onInit();
    _fetchPermissions();
  }

  Future<void> _fetchPermissions() async {
    isLoading.value = true;
    final result = await _repository.fetchAllRolePermissions();
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (roles) => rolePermissions.value = roles,
    );
    isLoading.value = false;
  }

  Future<void> savePermissions(String role, List<String> allowedModules) async {
    isLoading.value = true;
    final result = await _repository.updateRolePermissions(role, allowedModules);
    result.fold(
      (failure) => SnackbarHelper.showError('Error', failure.message),
      (_) {
        // Update local list
        final index = rolePermissions.indexWhere((r) => r.role == role);
        if (index != -1) {
          rolePermissions[index] = rolePermissions[index].copyWith(allowedModules: allowedModules);
        } else {
          rolePermissions.add(RolePermissionModel(role: role, allowedModules: allowedModules));
        }
        rolePermissions.refresh();
        SnackbarHelper.showSuccess('Success', 'Permissions Updated Successfully'); // SRS-82
      },
    );
    isLoading.value = false;
  }
}
