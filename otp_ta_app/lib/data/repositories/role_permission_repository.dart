import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/role_permission_model.dart';

abstract class IRolePermissionRepository {
  /// Fetch permissions for all roles
  Future<Either<Failure, List<RolePermissionModel>>> fetchAllRolePermissions();

  /// Update allowed modules for a specific role
  Future<Either<Failure, void>> updateRolePermissions(
    String role,
    List<String> allowedModules,
  );
}
