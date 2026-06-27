import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/role_permission_model.dart';
import 'role_permission_repository.dart';

class RolePermissionRepositoryImpl implements IRolePermissionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<RolePermissionModel>>> fetchAllRolePermissions() async {
    try {
      final snapshot = await _firestore.collection('role_permissions').get();
      
      // If collection is empty (e.g. first run), provide defaults
      if (snapshot.docs.isEmpty) {
        return Right([
          const RolePermissionModel(role: 'admin', allowedModules: ['Dashboard', 'Staff', 'Patients', 'Procedures', 'Reports', 'Settings']),
          const RolePermissionModel(role: 'doctor', allowedModules: ['Dashboard', 'Patients', 'Procedures']),
          const RolePermissionModel(role: 'receptionist', allowedModules: ['Dashboard', 'Patients']),
          const RolePermissionModel(role: 'patient', allowedModules: ['Dashboard', 'Profile', 'Appointments']),
        ]);
      }

      final roles = snapshot.docs.map((doc) => RolePermissionModel.fromMap(doc.data(), doc.id)).toList();
      return Right(roles);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to fetch role permissions.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateRolePermissions(String role, List<String> allowedModules) async {
    try {
      await _firestore
          .collection('role_permissions')
          .doc(role)
          .set({'allowedModules': allowedModules}, SetOptions(merge: true));
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update role permissions.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }
}
